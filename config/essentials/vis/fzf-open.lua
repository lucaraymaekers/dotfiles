--[[
Based on https://git.cepl.eu/cgit/vis/vis-fzf-open
Changes made:
- stylua
- height argument
- module renamed to M
- ignore exit code 130
--]]

-- Copyright (C) 2017  Guillaume Chérel
-- Copyright (C) 2023  Matěj Cepl
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
local M = {}

M.fzf_path = "fzf"
M.fzf_args = "--height=40%"

vis:command_register("fzf", function(argv)
	local fzf_path = M.fzf_path
	if argv[1] == "--search-path" then
		table.remove(argv, 1)
		local dir = table.remove(argv, 1)
		fzf_path = ([[FZF_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND --search-path ]] .. dir .. [[" fzf]])
	end

	local command = string.gsub(
		[[
            $fzf_path \
                --header="Enter:edit,^s:split,^v:vsplit" \
                --expect="ctrl-s,ctrl-v" \
                $fzf_args $args
        ]],
		"%$([%w_]+)",
		{
			fzf_path = fzf_path,
			fzf_args = M.fzf_args,
			args = table.concat(argv, " "),
		}
	)

	local file = io.popen(command)
	local output = {}
	for line in file:lines() do
		table.insert(output, line)
	end
	local _, _, status = file:close()

	if status == 0 then
		local action = "e"

		if output[1] == "ctrl-s" then
			action = "split"
		elseif output[1] == "ctrl-v" then
			action = "vsplit"
		end

		vis:feedkeys(string.format(":%s '%s'<Enter>", action, output[2]))
	elseif status == 1 then
		vis:info(string.format("fzf-open: No match. Command %s exited with return value %i.", command, status))
	elseif status == 2 then
		vis:info(string.format("fzf-open: Error. Command %s exited with return value %i.", command, status))
	elseif status ~= 130 then
		vis:info(
			string.format(
				"fzf-open: Unknown exit status %i. command %s exited with return value %i",
				status,
				command,
				status
			)
		)
	end

	vis:redraw()

	return true
end, "Select file to open with fzf")

return M
