vim.keymap.set("n", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1console.log(\\2);<cr><cmd>setlocal nohls<cr>")
vim.keymap.set("n", "<LocalLeader>i", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1console.log('\\2:', \\2);<cr><cmd>setlocal nohls<cr><esc>")
vim.keymap.set("i", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1console.log(\\2);<cr><cmd>setlocal nohls<cr><esc>A")
vim.keymap.set("i", "<LocalLeader>i", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1console.log('\\2:', \\2);<cr><cmd>setlocal nohls<cr><esc>A")
