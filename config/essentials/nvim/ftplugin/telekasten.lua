vim.keymap.set("i", "(", "()<Left>")
vim.keymap.set("i", "[", "[]<Left>")
vim.opt.spell = true

-- syntax highlighting
vim.cmd("hi tklink ctermfg=72 guifg=#81a1c1 cterm=bold,underline gui=bold,underline")
vim.cmd("hi tkBrackets ctermfg=gray guifg=gray")
vim.cmd("hi tkHighlight ctermbg=yellow ctermfg=red cterm=bold guibg=#ebcb8b guifg=black gui=bold")
vim.cmd("hi link CalNavi CalRuler")
vim.cmd("hi tkTagSep ctermfg=gray guifg=gray")
vim.cmd("hi tkTag ctermfg=175 guifg=#d3869B")
