--[[
Based on https://repo.or.cz/vis-complete-line.git
Changes made:
- stylua
- removed <C-x><C-e>, <C-x><C-y> and related functions and variables
--]]

-- SPDX-License-Identifier: GPL-3.0-or-later
-- © 2020 Georgi Kirilov
local progname = ...

local function concat_keys(tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	return table.concat(keys, "\n"), #keys
end

local function line_complete()
	local file = vis.win.file
	local sel = vis.win.selection
	local cur_line = file.lines[sel.line]
	local indent_patt = "^[ \t\v\f]+"
	local prefix = cur_line:sub(1, sel.col - 1):gsub(indent_patt, "")
	local candidates = {}
	for l in file:lines_iterator() do
		local unindented = l:gsub(indent_patt, "")
		local start, finish = unindented:find(prefix, 1, true)
		if start == 1 and finish < #unindented then
			candidates[unindented] = true
		end
	end
	local candidates_str, n = concat_keys(candidates)
	if n < 2 then
		if n == 1 then
			vis:insert(candidates_str:sub(#prefix + 1))
		end
		return
	end
	-- XXX: with too many candidates this command will become longer that the shell can handle:
	local command =
		string.format("vis-menu -l %d <<'EOF'\n%s\nEOF\n", math.min(n, math.ceil(vis.win.height / 2)), candidates_str)
	local status, output = vis:pipe(nil, nil, command)
	if n > 0 and status == 0 then
		vis:insert(output:sub(#prefix + 1):gsub("\n$", ""))
	end
end

vis.events.subscribe(vis.events.INIT, function()
	local function h(msg)
		return string.format("|@%s| %s", progname, msg)
	end

	vis:map(vis.modes.INSERT, "<C-x><C-l>", line_complete, h("Complete the current line"))
end)
