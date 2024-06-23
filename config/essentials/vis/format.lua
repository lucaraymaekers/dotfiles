--[[
Based on https://github.com/milhnl/vis-format
Changes made:
- stylua
- restore position after format
- use local M to return the module
--]]

local M = {}
M.check_same = true
M.wrapwidth = 90

M.stdio_formatter = function(cmd, options)
	local function apply(win, range, pos)
		local size = win.file.size
		local all = { start = 0, finish = size }
		if range == nil then
			range = all
		end
		local command = type(cmd) == "function" and cmd(win, range, pos) or cmd
		local check_same = (options and options.check_same ~= nil) and options.check_same or M.check_same
		local check = check_same == true or (type(check_same) == "number" and check_same >= size)
		local status, out, err = vis:pipe(win.file, all, command)
		if status ~= 0 then
			vis:message(err)
		elseif out == nil or out == "" then
			vis:info("No output from formatter")
		elseif not check or win.file:content(all) ~= out then
			local start, finish = range.start, range.finish
			win.file:delete(range)
			win.file:insert(start, out:sub(start + 1, finish + (out:len() - size)))
		end
		return pos
	end
	return {
		apply = apply,
		options = options or { ranged = type(cmd) == "function" },
	}
end

M.with_filename = function(win, option)
	if win.file.path then
		return option .. "'" .. win.file.path:gsub("'", "\\'") .. "'"
	else
		return ""
	end
end

M.formatters = {
	bash = M.stdio_formatter(function(win)
		return "shfmt " .. M.with_filename(win, "--filename ") .. " -"
	end),
	csharp = M.stdio_formatter("dotnet csharpier"),
	go = M.stdio_formatter("gofmt"),
	lua = {
		pick = function(win)
			local _, out = vis:pipe(
				win.file,
				{ start = 0, finish = win.file.size },
				"test -e .lua-format && echo luaformatter || echo stylua"
			)
			return M.formatters[out:gsub("\n$", "")]
		end,
	},
	luaformatter = M.stdio_formatter("lua-format"),
	markdown = M.stdio_formatter(function(win)
		if win.options and M.wrapwidth ~= 0 then
			return "prettier --parser markdown --prose-wrap always "
				.. ("--print-width " .. (M.wrapwidth - 1) .. " ")
				.. M.with_filename(win, "--stdin-filepath ")
		else
			return "prettier --parser markdown " .. M.with_filename(win, "--stdin-filepath ")
		end
	end, { ranged = false }),
	powershell = M.stdio_formatter([[
    "$( (command -v powershell.exe || command -v pwsh) 2>/dev/null )" -c '
        Invoke-Formatter  -ScriptDefinition `
          ([IO.StreamReader]::new([Console]::OpenStandardInput()).ReadToEnd())
      ' | sed -e :a -e '/^[\r\n]*$/{$d;N;};/\n$/ba'
  ]]),
	rust = M.stdio_formatter("rustfmt"),
	stylua = M.stdio_formatter(function(win, range)
		if range and (range.start ~= 0 or range.finish ~= win.file.size) then
			return "stylua -s --range-start "
				.. range.start
				.. " --range-end "
				.. range.finish
				.. M.with_filename(win, " --stdin-filepath ")
				.. " -"
		else
			return "stylua -s " .. M.with_filename(win, "--stdin-filepath ") .. " -"
		end
	end),
	text = M.stdio_formatter(function(win)
		if win.options and M.wrapwidth ~= 0 then
			return "fmt -w " .. (M.wrapwidth - 1)
		else
			return "fmt"
		end
	end, { ranged = false }),
}

local function getwinforfile(file)
	for win in vis:windows() do
		if win and win.file and win.file.path == file.path then
			return win
		end
	end
end

M.apply = function(file_or_keys, range, pos)
	local win = type(file_or_keys) ~= "string" and getwinforfile(file_or_keys) or vis.win
	local ret = type(file_or_keys) ~= "string" and function()
		return pos
	end or function()
		return 0
	end
	pos = pos or win.selection.pos
	local formatter = M.formatters[win.syntax]
	if formatter and formatter.pick then
		formatter = formatter.pick(win)
	end
	if formatter == nil then
		vis:info("No formatter for " .. win.syntax)
		return ret()
	end
	if range ~= nil and not formatter.options.ranged and range.start ~= 0 and range.finish ~= win.file.size then
		vis:info("Formatter for " .. win.syntax .. " does not support ranges")
		return ret()
	end
	pos = formatter.apply(win, range, pos) or pos
	vis:redraw()
	win.selection.pos = pos
	return ret()
end

return M
