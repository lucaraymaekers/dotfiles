------------------------------------
--- REQUIRES
------------------------------------
require("vis")

-- plugins
require("build")
-- use Trash directory instead, remove set_dir function
require("backup")
require("cursors")
require("title")
require("commentary")
require("complete-line")
-- removed formatting because already fulfilled by format.lua
require("vis-go")
-- set height to 40%
require("fzf-open")
require("vis-ultisnips")
-- TODO: doesn't work when using with 'e|b'
-- require("yank-highlight")

-- save position before formatting, use vis:redraw
local format = require("format")

-- set height to 40%
local fzfmru = require("fzf-mru")
fzfmru.fzfmru_path = 'grep "^' .. os.getenv("PWD") .. '" | fzf'

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

-- TOOD: use window selection to restore position
local function wrap_restore(f, ...)
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
	vis:command("!make && head -n 1")
end, "make")
vis:command_register("Q", function()
	vis:command("qa!")
end, "Quit all")
vis:command_register("delws", function()
	vis:command(",x/[ \t]+$|^[ \t]+$/d")
end, "Remove trailing whitespace")

-------------------------------------
--- MAPPINGS
-------------------------------------

vis:map(m.NORMAL, " pf", function()
	vis:command("fzf")
end, "Open file with fzf")
vis:map(m.NORMAL, " pr", function()
	vis:command("fzfmru")
end, "Open file with fzf")

vis:map(m.NORMAL, " r", function()
	wrap_restore(vis.command, vis, "e $vis_filepath")
end, "Reload active file")

vis:map(m.NORMAL, "=", format.apply, "Format active file")

map_cmd(m.NORMAL, " c", "e ~/.config/vis/visrc.lua", "Edit config file")
map_cmd(m.NORMAL, " q", "q!", "Quit (force)")
map_cmd(m.NORMAL, " s", "!doas vis $vis_filepath", "Edit as superuser")
map_cmd(m.NORMAL, " w", "w", "Write")
map_cmd(m.NORMAL, " x", "!chmod u+x $vis_filepath", "Make active file executable")

vis:map(m.NORMAL, " eh", function()
	vis:command("!lowdown $vis_filepath > ${vis_filepath%.md}.html")
	vis:info("exported.")
end, "Export markdown to html")

map_keys(m.NORMAL, " nl", ":<seq -f '%0.0f. ' 1 ", "Insert numbered list")

-- select markdown list element:	,x/^(\d+\.|[-*])\s+.+\n(^ .+\n)*/

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
	vis:info(win.file.name)
	win.options.relativenumbers = true

	if win.syntax == "bash" then
		map_keys(
			m.NORMAL,
			";p",
			"V:x/^(\\s*)(.+)$/ c/\\1>\\&2 printf '\\2: %s\\\\n' \"$\\2\"/<Enter><Escape>",
			"Print variable"
		)
		map_keys(m.NORMAL, ";v", 'V:x/^(\\s*)(.+)$/ c/\\1"$(\\2)"/<Enter><Escape>', "Surround in variable")
		map_keys(m.NORMAL, ";|", "V:x/\\| / c/|\n\t/<Enter><Escape>", "Wrap one-line multi pipe command")
		map_keys(
			m.NORMAL,
			";e",
			'V:x/^(\\s*)(.+)$/ c/\\1[ "\\2" ] || exit 1/<Enter><Escape>',
			"Condition exit if empty"
		)
		map_keys(m.NORMAL, ";sc", ":-/\\<case\\>/,/\\<esac\\>/<Enter>", "Expand to case")
		map_keys(m.NORMAL, ";sw", ":-/\\<while/,/\\<done\\>/<Enter>", "Expand to while")
		map_keys(m.NORMAL, ";sf", ":-/\\<for\\>/,/\\<done\\>/<Enter>", "Expand to for")
		map_keys(m.NORMAL, ";si", ":-/\\<if\\>/,/\\<fi\\>/<Enter>", "Expand to if")
	end
end)
