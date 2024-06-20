------------------------------------
--- LIBRARIES
------------------------------------
require('vis')

-- plugins
require("build")
require("backup")
require("cursors")
require("title")

vis:command_register("make", function() vis:communicate() end, "make")

------------------------------------
--- FUNCTIONS
------------------------------------

local map_cmd = function(mode, map, command, help)
    vis:map(mode, map, function() vis:command(command) end, help)
end

local map_cmd_restore = function(mode, map, command, help)
    vis:map(mode, map, function()
        if (mode == vis.modes.INSERT) then vis:feedkeys("<Escape>") end

        vis:feedkeys("m")
        vis:command(command)
        vis:feedkeys("M")

        if (mode == vis.modes.INSERT) then vis:feedkeys("i") end
    end, help)
end

local map_keys = function(mode, map, keys, help)
    vis:map(mode, map, function() vis:feedkeys(keys) end, help)
end

------------------------------------
--- VARIABLES
------------------------------------

local m = vis.modes

------------------------------------
--- COMMANDS
-----------------------------------

vis:command_register("Q", function() vis:command("qa!") end, "Quit all")
vis:command_register("delws",
                     function() vis:command("x/[ \t]+$|^[ \t]+$/d") end,
                     "Remove trailing whitespace")

-------------------------------------
--- MAPPINGS
-------------------------------------

map_cmd_restore(m.NORMAL, " r", "e $vis_filepath", "Reload active file")

map_cmd(m.NORMAL, " c", "e ~/.config/vis/visrc.lua", "Edit config file")
map_cmd(m.NORMAL, " q", "q!", "Quit (force)")
map_cmd(m.NORMAL, " s", "!doas vis $vis_filepath", "Edit as superuser")
map_cmd(m.NORMAL, " w", "w", "Write")
map_cmd(m.NORMAL, " x", "!chmod u+x $vis_filepath",
        "Make active file executable")

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

vis.events.subscribe(vis.events.WIN_OPEN,
                     function(win) -- luacheck: no unused args
    win.options.relativenumbers = true

    if win.syntax == "bash" then
        map_keys(m.NORMAL, " v",
                 "V:x/^(\\s*)(.+)$/ c/\\1>\\&2 printf '\\2: %s\\\\n' \"$\\2\"/<Enter><Escape>",
                 "Print variable")
    end
end)
