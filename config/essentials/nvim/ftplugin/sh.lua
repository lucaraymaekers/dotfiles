vim.keymap.set("n", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1printf \"\\2\"<cr>")
vim.keymap.set("n", "<LocalLeader>i", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1printf \"\\2: %s\\\\n\" \"$\\2\"<cr>")
vim.keymap.set("i", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1printf \"\\2\"<cr><esc>A")
vim.keymap.set("i", "<LocalLeader>i", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1printf \"\\2: %s\\\\n\" \"$\\2\"<cr><esc>A")
vim.keymap.set({"i", "n"}, "<LocalLeader>v", "<esc>A)\"<esc>I\"$(<esc>I")
vim.opt.formatoptions = "cqrnj"
