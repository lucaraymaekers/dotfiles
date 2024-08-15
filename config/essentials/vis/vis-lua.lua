vis:command_register("check", function(_, _, win)
	local fd = vis:communicate("check", "luacheck --no-color " .. win.file.path)
	if not fd then
		vis:info("error")
	end
	vis.events.subscribe(vis.events.PROCESS_RESPONSE, function(name, _, _, msg)
		if name ~= "check" then
			return
		end
		vis:message(msg)
	end)
end, "Check for errors in the file")
