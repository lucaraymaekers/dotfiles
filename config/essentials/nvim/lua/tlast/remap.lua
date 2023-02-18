vim.g.mapleader = " "
vim.g.localleader = "\\"

vim.keymap.set("n", "-", vim.cmd.Ex)

-- moving
vim.keymap.set("i", "<C-a>", "<C-o>I")
vim.keymap.set("i", "<C-e>", "<C-o>A")
vim.keymap.set("i", "<C-k>", "<C-o>D")

-- -- add closing
vim.keymap.set("i", '"', '""<Left>')
-- vim.keymap.set("i", "'", "''<Left>")
-- vim.keymap.set("i", "(", "()<Left>")
-- vim.keymap.set("i", "[", "[]<Left>")
-- vim.keymap.set("i", "{", "{}<Left>")
vim.keymap.set("i", "{<CR>", "{<CR>}<C-o>O")
vim.keymap.set("i", "{;<CR>", "{<CR>};<C-o>O")

-- buffers
vim.keymap.set("n", "gb", "<cmd>buffers<CR>:buffer<Space>")
vim.keymap.set("n", "<leader>q", "<cmd>q!<CR>")
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>")

-- Windows
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-h>", "<C-W>h")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-j>", "<C-W>j")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-k>", "<C-W>k")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-l>", "<C-W>l")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-o>", "<C-W>o")

-- move visual selection up/down wards
vim.keymap.set("v", "J",  "<cmd>m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", "<cmd>m '<-2<CR>gv=gv")

-- Don't move!
vim.keymap.set("n", "J", "mzJ`z")

-- clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>o", "<Plug>OSCYank")

-- scripts
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true})

-- replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w><C-w>/gI<Left><Left><Left>]])

-- templates
vim.keymap.set("n", "<leader>rt", ":r " .. vim.fn.stdpath("config") .. "/templates/")

-- hide all
local s = {hidden_all = 0}
vim.keymap.set("n", "<C-h>", function ()
	s.hidden_all = 1 - s.hidden_all
	local opt = s.hidden_all == 0
	vim.opt.showmode = opt
	vim.opt.ruler = opt
	vim.opt.nu = opt
	vim.opt.rnu = opt
	vim.opt.showcmd = opt
	vim.opt.laststatus = opt and 2 or 0
	vim.opt.signcolumn = opt and "yes" or "no"
end)

-- random
vim.keymap.set("i", "<LocalLeader>r", "<cmd>r!echo -n $RANDOM<cr><esc>kJA")

-- write
vim.keymap.set("n", "<LocalLeader>w", "<cmd>write<CR>")
vim.keymap.set("n", "<LocalLeader>W", "<cmd>write!<CR>")
