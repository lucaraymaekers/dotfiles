vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- -- vinegar is already doing this
-- vim.keymap.set("n", "-", vim.cmd.Ex)

-- moving
vim.keymap.set("i", "<C-a>", "<C-o>I", { noremap = true })
vim.keymap.set("i", "<C-e>", "<C-o>A", { noremap = true })
vim.keymap.set("i", "<C-k>", "<C-o>D", { noremap = true })

vim.keymap.set("i", "{<cr>", "{<cr>}<C-o>O", { noremap = true })
vim.keymap.set("i", "{;<cr>", "{<cr>};<C-o>O", { noremap = true })

-- buffers
vim.keymap.set("n", "gb", "<cmd>buffers<cr>:buffer<Space>", { noremap = true })
vim.keymap.set("n", "<Leader>q", "<cmd>q!<cr>", { noremap = true })
vim.keymap.set("n", "<Leader>Q", "<cmd>qa!<cr>", { noremap = true })

-- Windows
vim.keymap.set("n", "<A-h>", "<C-W>h", { noremap = true })
vim.keymap.set("n", "<A-j>", "<C-W>j", { noremap = true })
vim.keymap.set("n", "<A-k>", "<C-W>k", { noremap = true })
vim.keymap.set("n", "<A-l>", "<C-W>l", { noremap = true })
vim.keymap.set("n", "<A-o>", "<C-W>o", { noremap = true })
-- command line
vim.keymap.set("c", "<M-b>", "<C-Left>", { noremap = true })
vim.keymap.set("c", "<M-f>", "<C-Right>", { noremap = true })
vim.keymap.set("c", "<M-d>", "<C-Right><C-w>", { noremap = true })

-- move visual selection up/down wards
vim.keymap.set("v", "J",  "<cmd>m '>+1<cr>gv=gv<cr>", { noremap = true })
vim.keymap.set("v", "K", "<cmd>m '<-2<cr>gv=gv<cr>", { noremap = true })

-- clipboard
vim.keymap.set("n", "<Leader>y", "\"+y", { noremap = true })

-- templates
vim.keymap.set("n", "<LocalLeader>rt", ":-1r " .. vim.fn.stdpath("config") .. "/templates", { noremap = true })

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
end, { noremap = true })

-- utils
vim.keymap.set("i", "<LocalLeader>r", "<cmd>r!echo -n $RANDOM<cr><esc>kJA", { noremap = true })
-- ordered list
vim.keymap.set("n", "<LocalLeader>n", "0vap<C-v>I0. <esc>gvg<C-a>", { noremap = true })
vim.keymap.set("v", "<Leader>u", "<cmd>'<,'>s/^[0-9]\\+\\. //<cr><esc>", { noremap = true })
-- scripts
vim.keymap.set("n", "<Leader>x", "<cmd>!chmod +x %<cr>", { noremap = true, silent = true})
-- replace
vim.keymap.set("n", "<Leader>sf", [[:%s/\<<C-r><C-w>\>/<C-r><C-w><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<Leader>sl", [[:s/\<<C-r><C-w>\>/<C-r><C-w><C-w>/gI<Left><Left><Left>]])

-- write
vim.keymap.set("n", "<LocalLeader>w", "<cmd>write<cr>", { noremap = true })
vim.keymap.set("n", "<LocalLeader>W", "<cmd>write!<cr>", { noremap = true })
vim.keymap.set("n", "<LocalLeader>e", "<cmd>edit<cr>", { noremap = true })
vim.keymap.set("n", "<LocalLeader>s", function ()
	vim.cmd.source()
	print("sourced.")
end, { noremap = true })

-- Packer
vim.keymap.set("n", "<Leader>P", "<cmd>PackerSync<cr>", { noremap = true })

-- spelling
vim.keymap.set("n", "<Leader><C-s>", "<cmd>setlocal spell!<cr>", { noremap = true })

-- open terminal in file's parent director
-- this needs to be asynchrous
vim.keymap.set("n", "<Return>", function ()
    local cmd = "cd " .. vim.fn.expand("%:p:h") .. "; setsid st"
	-- asynchrous go brr
    vim.fn.jobstart(cmd, { on_exit = function(job_id, exit_code, event_type) end })
end, { noremap = true })


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
end, { noremap = true })
