require("vis")

local M = {
	style = "reverse", -- Style used for highlighting
	duration = 0.2,    -- [s] Time to remain highlighted (10 ms precision)
}

vis.events.subscribe(vis.events.INIT, function()
	local yank = vis:action_register("highlighted-yank", function()
		vis.win:style_define(vis.win.STYLE_SELECTION, M.style)
		vis:redraw()
		local tstamp = os.clock()
		while os.clock() - tstamp < M.duration do end
		vis.win:style_define(vis.win.STYLE_SELECTION, vis.lexers.STYLE_SELECTION)
		vis:redraw()
		vis:feedkeys("<vis-operator-yank>")
	end, "Yank operator with highlighting")
	vis:map(vis.modes.OPERATOR_PENDING, "y", yank)
	vis:map(vis.modes.VISUAL, "y", yank)
	vis:map(vis.modes.VISUAL_LINE, "y", yank)

	vis:map(vis.modes.NORMAL, "y", function(keys)
		local sel_end_chrs = "$%^{}()wp"
		if #keys < 1 or sel_end_chrs:find(keys:sub(-1), 1, true) == nil then
			if keys:find("<Escape>") then
				return #keys
			end
			return -1
		end
		vis:feedkeys("<vis-mode-visual-charwise>")
		vis:feedkeys(keys)
		vis:feedkeys("y<Escape>")
		return #keys
	end)
end)

return M
