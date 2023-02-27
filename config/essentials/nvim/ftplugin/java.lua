vim.keymap.set("n", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1System.out.println(\\2);<cr><cmd>setlocal nohls<cr>")
vim.keymap.set("i", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1System.out.println(\\2);<cr><cmd>setlocal nohls<cr><esc>A")
