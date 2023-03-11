local opt = vim.opt

opt.clipboard = "unnamed"

opt.termguicolors = true

opt.number = true
opt.relativenumber = true
opt.showmatch = true
opt.matchtime = 0
opt.showcmd = true
opt.cursorline = true
opt.ruler = true

opt.path:append("**")

opt.wildmenu = true
opt.incsearch = true
opt.hlsearch = false

opt.mouse = ""

opt.tabstop = 4
opt.shiftwidth = 4
opt.backspace = "indent,eol,start"

opt.signcolumn = "yes"
opt.updatetime = 100
opt.laststatus = 2
opt.history = 200
opt.encoding = "utf-8"

opt.smartindent = true
opt.scrolloff = 8

opt.ignorecase = true
opt.smartcase = true

opt.swapfile = false
opt.backup = false

opt.spelllang = "en_us,nl"
opt.formatoptions = "cqrnj"
