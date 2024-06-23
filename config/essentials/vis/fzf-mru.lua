--[[
Based on https://github.com/peaceant/vis-fzf-mru
Changes made:
- stylua
- renamed module to M
- renamed fzfmru to fzf
- height to 40%
- use XDG_CACHE_HOME
- ignore exit code 130
--]]

local M = {}
M.fzf_filepath = os.getenv("XDG_CACHE_HOME") .. "/vis-fzf-mru"
M.fzf_path = "fzf"
M.fzf_args = "--height=40%"
M.fzf_history = 20

local function read_mru()
    local mru = {}
    local f = io.open(M.fzf_filepath)
    if f == nil then return end
    for line in f:lines() do table.insert(mru, line) end
    f:close()

    return mru
end

local function write_mru(win)
    local file_path = win.file.path
    local mru = read_mru()

    -- check if mru data exists
    if mru == nil then mru = {} end
    -- check if we opened any file
    if file_path == nil then return end
    -- check duplicate
    if file_path == mru[1] then return end

    local f = io.open(M.fzf_filepath, "w+")
    if f == nil then return end

    table.insert(mru, 1, file_path)

    for i, k in ipairs(mru) do
        if i > M.fzf_history then break end
        if i == 1 or k ~= file_path then
            f:write(string.format("%s\n", k))
        end
    end

    f:close()
end

vis.events.subscribe(vis.events.WIN_OPEN, write_mru)

vis:command_register("fzfmru", function(argv)
    local command = "cat " .. M.fzf_filepath .. " | " ..
                        M.fzf_path .. " " .. M.fzf_args .. " " ..
                        table.concat(argv, " ")

    local file = io.popen(command)
    local output = file:read()
    local _, _, status = file:close()

    if status == 0 then
        vis:command(string.format("e '%s'", output))
    elseif status == 1 then
        vis:info(string.format(
                     "fzf-open: No match. Command %s exited with return value %i.",
                     command, status))
    elseif status == 2 then
        vis:info(string.format(
                     "fzf-open: Error. Command %s exited with return value %i.",
                     command, status))
    elseif status ~= 130 then
        vis:info(string.format(
                     "fzf-open: Unknown exit status %i. command %s exited with return value %i",
                     status, command, status, status))
    end

    vis:redraw()

    return true
end)

return M
