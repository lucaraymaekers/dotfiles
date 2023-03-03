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
vim.keymap.set("n", "gb", "<CMD>buffers<CR>:buffer<Space>")
vim.keymap.set("n", "<Leader>q", "<CMD>q!<CR>")
vim.keymap.set("n", "<Leader>Q", "<CMD>qa!<CR>")

-- Windows
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-h>", "<C-W>h")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-j>", "<C-W>j")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-k>", "<C-W>k")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-l>", "<C-W>l")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-o>", "<C-W>o")

-- move visual selection up/down wards
vim.keymap.set("v", "J",  "<CMD>m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", "<CMD>m '<-2<CR>gv=gv")

-- Don't move!
vim.keymap.set("n", "J", "mzJ`z")

-- clipboard
vim.keymap.set("n", "<Leader>y", "\"+y")
vim.keymap.set("n", "<Leader>o", "<Plug>OSCYank")

-- scripts
vim.keymap.set("n", "<Leader>x", "<CMD>!chmod +x %<CR>", { silent = true})

-- replace
vim.keymap.set("n", "<Leader>rf", [[:%s/\<<C-r><C-w>\>/<C-r><C-w><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<Leader>rl", [[:s/\<<C-r><C-w>\>/<C-r><C-w><C-w>/gI<Left><Left><Left>]])

-- templates
vim.keymap.set("n", "<Leader>rt", ":r " .. vim.fn.stdpath("config") .. "/templates/")

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
vim.keymap.set("i", "<LocalLeader>r", "<CMD>r!echo -n $RANDOM<CR><esc>kJA")

-- write
vim.keymap.set("n", "<LocalLeader>w", "<CMD>write<CR>")
vim.keymap.set("n", "<LocalLeader>W", "<CMD>write!<CR>")
vim.keymap.set("n", "<LocalLeader>e", "<CMD>edit<CR><CMD>set nohls<CR>")
vim.keymap.set("n", "<Leader><M-s>", "<CMD>source<CR>")

-- spelling
vim.keymap.set("n", "<Leader><C-s>", "<CMD>setlocal spell!<CR>")

-- open terminal in file's parent director
vim.keymap.set("n", "<Return>", "<CMD>silent !cd %:p:h && $TERMINAL<CR>")
