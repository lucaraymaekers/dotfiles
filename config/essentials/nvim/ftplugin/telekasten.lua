-- vim.opt.spell = true
vim.opt.textwidth = 65
vim.opt.signcolumn = "no"

-- syntax highlighting
vim.cmd("hi tklink ctermfg=72 guifg=#81a1c1 cterm=bold,underline gui=bold,underline")
vim.cmd("hi tkBrackets ctermfg=gray guifg=gray")
vim.cmd("hi tkHighlight ctermbg=yellow ctermfg=red cterm=bold guibg=#ebcb8b guifg=black gui=bold")
vim.cmd("hi link CalNavi CalRuler")
vim.cmd("hi tkTagSep ctermfg=gray guifg=gray")
vim.cmd("hi tkTag ctermfg=175 guifg=#d3869B")

vim.keymap.set("n", "<LocalLeader>a", require("telekasten").show_tags)
vim.keymap.set("n", "<LocalLeader>b", require("telekasten").show_backlinks)
vim.keymap.set("n", "<LocalLeader>c", require("telekasten").show_calendar)
vim.keymap.set("n", "<LocalLeader>C", "<cmd>CalendarT<cr>")
vim.keymap.set({"n", "i"}, "<LocalLeader>i", "<Esc><cmd>Telekasten insert_link<cr>")
vim.keymap.set({"n", "i"}, "<LocalLeader>I", require("telekasten").insert_img_link)
vim.keymap.set("n", "<LocalLeader>F", require("telekasten").find_friends)
vim.keymap.set("n", "<LocalLeader>r", require("telekasten").rename_note)
vim.keymap.set("n", "<LocalLeader>t", require("telekasten").toggle_todo)
vim.keymap.set("i", "<LocalLeader>t", "<cmd>Telekasten toggle_todo<cr><Esc>A")
vim.keymap.set("n", "<LocalLeader>y", require("telekasten").yank_notelink)
vim.keymap.set("n", "<LocalLeader>z", require("telekasten").follow_link)

vim.keymap.set("i", "<LocalLeader>l", "<esc>I[<esc>A]()<left><C-r>+<esc>A")
