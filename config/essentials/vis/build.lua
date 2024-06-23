--[[
Based on https://gitlab.com/muhq/vis-build
Changes made:
- stylua format
- print build messages on success
--]]


-- Copyright (c) 2024 Florian Fischer. All rights reserved.
--
-- vis-build is free software: you can redistribute it and/or modify it under
-- the terms of the GNU General Public License as published by the Free Software
-- Foundation, either version 3 of the License, or (at your option) any later
-- version.
--
-- vis-build is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along with
-- vis-build found in the LICENSE file.
-- If not, see <https://www.gnu.org/licenses/>.
local M = {}
M.get_default_build_cmd = function() return 'make' end

local build_id = 0
local builds = {}

M.new_build = function(cmd)
    build_id = build_id + 1
    local build_name = 'build' .. build_id
    local build_fd = vis:communicate(build_name, cmd)
    local build = {fd = build_fd, out = '', err = '', cmd = cmd}
    builds[build_name] = build
end

vis.events.subscribe(vis.events.PROCESS_RESPONSE,
                     function(name, event, code, msg)
    local build = builds[name]
    if not build then return end

    if event == 'EXIT' or event == 'SIGNAL' then
        if code ~= 0 then
            vis:message('build: ' .. name .. ' cmd: ' .. build.cmd)
            if event == 'EXIT' then
                vis:message('failed with: ' .. code)
            else
                vis:message('got signal: ' .. code)
            end
            vis:message('stdout:\n' .. build.out)
            vis:message('stderr:\n' .. build.err)
        else
            vis:message(name .. ':\n' .. build.out)
        end
        builds[name] = nil
    end

    if event == 'STDOUT' then
        build.out = build.out .. msg
    elseif event == 'STDERR' then
        build.err = build.err .. msg
    end
end)

vis:command_register('build', function(argv)
    M.new_build(argv[1] or M.get_default_build_cmd())
end, 'Asynchronously build the current file or project')

vis:map(vis.modes.NORMAL, '<M-b>', function()
    vis:command('build')
    return 0
end, 'Asynchronously build the current file or project')

return M
