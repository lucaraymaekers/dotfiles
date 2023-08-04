local M = {}
-- keep track of jobs
local live_servers = {}

function M.start_live_server()
	if vim.fn.executable('lsof') == 0 then
		print("Error: 'lsof' command not found")
	elseif vim.fn.executable('live-server') == 0 then
		print("Error: 'live-server' command not found")
		return
	end

	-- Search for available port and use it
    local port = 5500
    local running = true
    while running do
        local output = vim.fn.systemlist('lsof -i :' .. port)
        if #output == 0 then
            running = false
        else
            port = port + 1
        end
    end

    local command = "live-server --no-browser --port=" .. port .. " \"" .. vim.fn.expand("%:p:h") .. "\""
	-- run
    local job_id = vim.fn.jobstart(command, {
        on_exit = function(_, _, _) end
    })
	-- save
    live_servers[port] = job_id

    print("Started live-server on :" .. port .. ".")
end

function M.stop_live_servers()
    for port, job_id in pairs(live_servers) do
        local output = vim.fn.systemlist('lsof -i :' .. port)
        if #output > 0 then
            vim.fn.jobstop(job_id)
            print("Killed live-server on :" .. port .. ".")
        end
        live_servers[port] = nil
    end
end

vim.api.nvim_create_user_command("LiveServer", function(opts)
	local opt = string.format(opts.args)
	if #opts.args == 0 then
		M.start_live_server()
	elseif opt == "start" then
		M.start_live_server()
	elseif opt == "stop" then
		M.stop_live_servers()
	else
		print("Invalid argument. Usage: LiveServer [start|stop]")
	end
end, { nargs = '*' })

return M
