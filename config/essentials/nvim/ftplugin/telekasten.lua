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

vim.keymap.set("n", "<LocalLeader>a", "<cmd>Telekasten show_tags<cr>")
vim.keymap.set("n", "<LocalLeader>b", "<cmd>Telekasten show_backlinks<cr>")
vim.keymap.set("n", "<LocalLeader>c", "<cmd>Telekasten show_calendar<cr>")
vim.keymap.set("n", "<LocalLeader>C", "<cmd>CalendarT<cr>")
vim.keymap.set({"n", "i"}, "<LocalLeader>i", "<Esc><cmd>Telekasten insert_link<cr>")
vim.keymap.set({"n", "i"}, "<LocalLeader>I", "<cmd>Telekasten insert_img_link<cr>")
vim.keymap.set("n", "<LocalLeader>F", "<cmd>Telekasten find_friends<cr>")
vim.keymap.set("n", "<LocalLeader>r", "<cmd>Telekasten rename_note<cr>")
vim.keymap.set("n", "<LocalLeader>t", "<cmd>Telekasten toggle_todo<cr>")
vim.keymap.set("i", "<LocalLeader>t", "<cmd>Telekasten toggle_todo<cr><Esc>A")
vim.keymap.set("n", "<LocalLeader>y", "<cmd>Telekasten yank_notelink<cr>")
vim.keymap.set("n", "<LocalLeader>z", "<cmd>Telekasten follow_link<cr>")

vim.keymap.set("i", "<LocalLeader>l", "<esc>I[<esc>A]()<left><C-r>+<esc>A")
