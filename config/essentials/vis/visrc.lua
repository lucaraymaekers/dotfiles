------------------------------------
--- REQUIRES
------------------------------------
require("vis")

-- plugins
require("build")
-- use Trash directory instead, remove set_dir function
require("backup")
require("cursors")
require("ctags")
require("title")
require("commentary")
require("complete-line")
-- set height to 40%
require("fzf-open")
require("vis-ultisnips")
-- TODO: doesn't work when using with 'e|b'
-- require("yank-highlight")

-- save position before formatting, use vis:redraw
local format = require("format")

-- set height to 40%
local fzfmru = require("fzf-mru")
fzfmru.fzfmru_path = 'grep "^' .. io.popen("pwd"):read("*a"):gsub("\n$", "") .. '" | fzf'

-- todo:
-- c-scope
-- c-tags
-- ...
-- vis-goto, favor open-file-under-cursor
-- ...
-- ultisnips
-- ...
-- vis-yank-highlight

------------------------------------
--- VARIABLES
------------------------------------
local m = vis.modes

------------------------------------
--- FUNCTIONS
------------------------------------

local function map_cmd(mode, map, command, help)
	vis:map(mode, map, function()
		vis:command(command)
	end, help)
end

-- Store and pop position with command ran in between
local function wrap_pos_restore(f, ...)
	local pos = vis.win.selection.pos
	f(...)
	vis.win.selection.pos = pos
end

local function map_keys(mode, map, keys, help)
	vis:map(mode, map, function()
		vis:feedkeys(keys)
	end, help)
end

------------------------------------
--- COMMANDS
-----------------------------------

vis:command_register("make", function()
	vis:command("!make; head -n 1")
end, "make")
vis:command_register("Q", function()
	vis:command("qa!")
end, "Quit all")
vis:command_register("delws", function()
	vis:command(",x/[ \t]+$|^[ \t]+$/d")
end, "Remove trailing whitespace")
vis:command_register("redraw", function() vis:redraw() end, "Redraw UI")

-------------------------------------
--- MAPPINGS
-------------------------------------

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	map_cmd(m.NORMAL, " pf", "fzf", "Open file with fzf")
	map_cmd(m.NORMAL, " pr", "fzfmru", "Open file with fzf")

	vis:map(m.NORMAL, " r", function()
		wrap_pos_restore(vis.command, vis, "e $vis_filepath")
	end, "Reload active file")
	vis:map(m.NORMAL, "=", format.apply, "Format active file")
	map_cmd(m.NORMAL, "<M-m>", "make", "Run 'make'")
	map_cmd(m.NORMAL, " c", "e ~/.config/vis/visrc.lua", "Edit config file")
	map_cmd(m.NORMAL, " q", "q!", "Quit (force)")
	map_cmd(m.NORMAL, " s", "!doas vis $vis_filepath", "Edit as superuser")
	map_cmd(m.NORMAL, " w", "w", "Write")
	map_cmd(m.NORMAL, " x", "!chmod u+x $vis_filepath", "Make active file executable")
	map_cmd(m.NORMAL, "!", "!bash", "Run bash")
	map_keys(m.NORMAL, " y", '"+y', "Copy to system clipboard")
	map_keys(m.VISUAL, " y", '"+y', "Copy to system clipboard")
	map_keys(m.NORMAL, " nl", ":<seq -f '%0.0f. ' 1 ", "Insert numbered list")
	map_keys(m.NORMAL, "<M-S-Down>", "ddp", "Move line down")
	map_keys(m.NORMAL, "<M-S-Up>", "ddkP", "Move line up") -- Doesn't work at end of file
end)

------------------------------------
--- EVENTS
------------------------------------

vis.events.subscribe(vis.events.INIT, function()
	vis.options.ignorecase = true
	vis.options.autoindent = true
	vis.options.shell = "/bin/sh"
	local theme = "nord"
	vis:command("set theme " .. theme)
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	-- automatically cd in parent dir of file
	vis:command_register("cdp", function()
		if win and win.file and win.file.path then
			local dir = win.file.path:match(".*/")
			vis:info("cd " .. tostring(dir))
		end
	end, "Cd to parent dir of file")

	win.options.relativenumbers = true

	if win.syntax then
		vis:info(win.syntax)
	end

	-- FILETYPE OPTIONS
	if win.syntax == "ansi_c" then
		map_keys(m.NORMAL, "\\a", "f,a <Escape>hdw<S-Tab>i<Tab><Escape>", "Align table")
	end

	if win.syntax == "bash" then
		vis:command_register("curl", function()
			vis:command("x/ -H/ c/\\\n\t-H/")
		end, "Split curl command on multiple lines")
		map_keys(
			m.NORMAL,
			"\\p",
			"V:x/^(\\s*)(.+)$/ c/\\1>\\&2 printf '\\2: %s\\\\n' \"$\\2\"/<Enter><Escape>",
			"Print variable"
		)
		map_keys(m.NORMAL, "\\v", 'V:x/^(\\s*)(.+)$/ c/\\1"$(\\2)"/<Enter><Escape>', "Surround in variable")
		map_keys(m.NORMAL, "\\|", "V:x/\\| / c/|\n\t/<Enter><Escape>", "Wrap one-line multi pipe command")
		map_keys(
			m.NORMAL,
			"\\e",
			'V:x/^(\\s*)(.+)$/ c/\\1[ "$\\2" ] || exit 1/<Enter><Escape>',
			"Condition exit if empty"
		)
		map_cmd(m.NORMAL, "\\sc", "-/\\<case\\>/,/\\<esac\\>/", "Expand to case")
		map_cmd(m.NORMAL, "\\sw", "-/\\<while/,/\\<done\\>/", "Expand to while")
		map_cmd(m.NORMAL, "\\sf", "-/\\<for\\>/,/\\<done\\>/", "Expand to for")
		map_cmd(m.NORMAL, "\\si", "-/\\<if\\>/,/\\<fi\\>/", "Expand to if")
	end

	if win.syntax == "go" then
		require("vis-go")
	end

	if win.syntax == "lua" then
		require("vis-lua")
	end

	if win.syntax == "markdown" then
		win.options.tabwidth = 2
		win.options.expandtab = true
		vis:map(m.NORMAL, "\\h", function()
			vis:command("!lowdown $vis_filepath > ${vis_filepath%.md}.html")
			vis:info("exported.")
		end, "Export markdown to html")
		map_cmd(m.NORMAL, "\\sl", "-+x/(\\d+|[-*])\\s+.+\n/", "Expand to list item")
		map_cmd(m.NORMAL, "\\sh", "-/^#+/,/^#+/-", "Expand to header")
		-- select header block by name
		-- ,x/^# Planning\n([^#]|\n)+
	end

	if win.syntax == "yaml" then
		win.options.tabwidth = 2
		win.options.expandtab = true
	end
end)
