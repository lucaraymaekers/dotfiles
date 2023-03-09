vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "-", vim.cmd.Ex)

-- moving
vim.keymap.set("i", "<C-a>", "<C-o>I")
vim.keymap.set("i", "<C-e>", "<C-o>A")
vim.keymap.set("i", "<C-k>", "<C-o>D")

vim.keymap.set("i", "{<cr>", "{<cr>}<C-o>O")
vim.keymap.set("i", "{;<cr>", "{<cr>};<C-o>O")

-- buffers
vim.keymap.set("n", "gb", "<cmd>buffers<cr>:buffer<Space>")
vim.keymap.set("n", "<Leader>q", "<cmd>q!<cr>")
vim.keymap.set("n", "<Leader>Q", "<cmd>qa!<cr>")

-- Windows
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-h>", "<C-W>h")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-j>", "<C-W>j")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-k>", "<C-W>k")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-l>", "<C-W>l")
vim.keymap.set({"n", "i", "v", "c", "o", "s", "x"}, "<A-o>", "<C-W>o")
-- command line
vim.keymap.set("c", "<M-b>", "<C-Left>")
vim.keymap.set("c", "<M-f>", "<C-Right>")
vim.keymap.set("c", "<M-d>", "<C-Right><C-w>")

-- move visual selection up/down wards
vim.keymap.set("v", "J",  "<cmd>m '>+1<cr>gv=gv<cr>")
vim.keymap.set("v", "K", "<cmd>m '<-2<cr>gv=gv<cr>")

-- clipboard
vim.keymap.set("n", "<Leader>y", "\"+y")
vim.keymap.set("n", "<Leader>o", "<Plug>OSCYank")

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

-- utils
vim.keymap.set("i", "<LocalLeader>r", "<cmd>r!echo -n $RANDOM<cr><esc>kJA")
-- ordered list
vim.keymap.set("v", "<Leader>n", "I0. <esc>gvg<C-a>")
vim.keymap.set("v", "<Leader>u", "<cmd>'<,'>s/^[0-9]\\+\\. //<cr><esc>")
-- scripts
vim.keymap.set("n", "<Leader>x", "<cmd>!chmod +x %<cr>", { silent = true})
-- replace
vim.keymap.set("n", "<Leader>rf", [[:%s/\<<C-r><C-w>\>/<C-r><C-w><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<Leader>rl", [[:s/\<<C-r><C-w>\>/<C-r><C-w><C-w>/gI<Left><Left><Left>]])

-- write
vim.keymap.set("n", "<LocalLeader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<LocalLeader>W", "<cmd>write!<cr>")
vim.keymap.set("n", "<LocalLeader>e", "<cmd>edit<cr>")
vim.keymap.set("n", "<LocalLeader>s", function ()
	vim.cmd.source()
	print("sourced.")
end)

-- Packer
vim.keymap.set("n", "<Leader>P", "<cmd>PackerSync<cr>")

-- spelling
vim.keymap.set("n", "<Leader><C-s>", "<cmd>setlocal spell!<cr>")

-- open terminal in file's parent director
-- this needs to be asynchrous
vim.keymap.set("n", "<Return>", function ()
    local cmd = "cd " .. vim.fn.expand("%:p:h") .. "; setsid st"
    vim.fn.jobstart(cmd, {
        on_exit = function(job_id, exit_code, event_type)
            -- Do nothing here
        end
    })
end)


-- clear registers
vim.keymap.set("n", "<Leader>rc", function ()
	local regs = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
				  'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
				  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
				  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
				  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '/', '-', '"'}
	for _, r in ipairs(regs) do
	  vim.fn.setreg(r, {})
	end
end)
