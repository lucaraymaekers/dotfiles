-- SPDX-License-Identifier: GPL-3.0-or-later
-- © 2020 Georgi Kirilov
local progname = ...

local lpeg = require("lpeg")
local R, C, Cmt = lpeg.R, lpeg.C, lpeg.Cmt

-- copied from vis.h
local VIS_MOVE_NOP = 64

local cont = R("\128\191")

local charpattern = R("\0\127") + R("\194\223") * cont + R("\224\239") * cont *
                        cont + R("\240\244") * cont * cont * cont

local function concat_keys(tbl)
    local keys = {}
    for k in pairs(tbl) do table.insert(keys, k) end
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
        if n == 1 then vis:insert(candidates_str:sub(#prefix + 1)) end
        return
    end
    -- XXX: with too many candidates this command will become longer that the shell can handle:
    local command = string.format("vis-menu -l %d <<'EOF'\n%s\nEOF\n",
                                  math.min(n, math.ceil(vis.win.height / 2)),
                                  candidates_str)
    local status, output = vis:pipe(nil, nil, command)
    if n > 0 and status == 0 then
        vis:insert(output:sub(#prefix + 1):gsub("\n$", ""))
    end
end

local function selection_by_pos(pos)
    for s in vis.win:selections_iterator() do
        if s.pos == pos then return s end
    end
end

local function charwidth(cells_so_far, char)
    if char == "\t" then
        local tw = vis.tabwidth or 8
        local trail = cells_so_far % tw
        return tw - trail
    else
        return 1
    end
end

local function virtcol(line, col)
    local ncells = 0
    local nchars = 0
    local function upto(_, _, char)
        if nchars < col - 1 then
            ncells = ncells + charwidth(ncells, char)
            nchars = nchars + 1
            return true
        end
    end
    (Cmt(C(charpattern), upto) ^ 0):match(line)
    return ncells + 1
end

local function neighbor(lines, ln, col, direction)
    local line = ln + direction > 0 and lines[ln + direction]
    if not line then return end
    local column = virtcol(lines[ln], col)
    local ncells = 0
    local function upto(_, _, char)
        ncells = ncells + charwidth(ncells, char)
        return ncells < column
    end
    return
        (Cmt(C(charpattern), upto) ^ (-column + 1) / 0 * C(charpattern)):match(
            line)
end

local function dup_neighbor(direction)
    return function(file, _, pos)
        local sel = selection_by_pos(pos)
        local char = neighbor(file.lines, sel.line, sel.col, direction)
        if not char then return pos end
        file:insert(pos, char)
        return pos + #char
    end
end

local function dup_neighbor_feedkeys(direction)
    local sel = vis.win.selection
    local file = vis.win.file
    local char = neighbor(file.lines, sel.line, sel.col, direction)
    if not char then return end
    vis:feedkeys(char)
end

local function operator(handler)
    local id = vis:operator_register(handler)
    return id >= 0 and function()
        vis:operator(id)
        vis:motion(VIS_MOVE_NOP)
    end
end

vis.events.subscribe(vis.events.INIT, function()
    local function h(msg) return string.format("|@%s| %s", progname, msg) end

    local function column_complete(direction)
        local binding = operator(dup_neighbor(direction))
        return function()
            if #vis.win.selections == 1 then
                dup_neighbor_feedkeys(direction)
            else
                return binding()
            end
        end
    end

    vis:map(vis.modes.INSERT, "<C-y>", column_complete(-1),
            h "Insert the character which is above the cursor")
    vis:map(vis.modes.INSERT, "<C-e>", column_complete(1),
            h "Insert the character which is below the cursor")
    vis:map(vis.modes.INSERT, "<C-x><C-l>", line_complete,
            h "Complete the current line")
end)
