vim.keymap.set("n", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1echo \"\\2\"<cr><cmd>setlocal nohls<cr>")
vim.keymap.set("n", "<LocalLeader>i", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1echo \"\\2: ${\\2}\"<cr><cmd>setlocal nohls<cr>")
vim.opt.formatoptions = "cqrnj"
