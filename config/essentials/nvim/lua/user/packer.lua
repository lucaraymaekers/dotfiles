return require('packer').startup(function(use)
	use('wbthomason/packer.nvim')

	-- files
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use {'nvim-telescope/telescope-ui-select.nvim' }

	use('nvim-telescope/telescope-symbols.nvim')
	use('theprimeagen/harpoon')

	-- colors
	use('shaunsingh/nord.nvim')
	use { 'uZer/pywal16.nvim', as = 'pywal16' }
	use('norcalli/nvim-colorizer.lua')

	use('airblade/vim-gitgutter')

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use('nvim-treesitter/playground')
	use('theRealCarneiro/hyprland-vim-syntax')

	use('mbbill/undotree')

	use('tpope/vim-capslock')
	use('tpope/vim-commentary')
	-- use('tpope/vim-endwise')
	use('tpope/vim-fugitive')
	use('tpope/vim-repeat')
	use('tpope/vim-surround')
	use('tpope/vim-vinegar')
	use('m4xshen/autoclose.nvim')

	-- utils
	use('godlygeek/tabular')
	use('renerocksai/calendar-vim')
	use('ojroques/vim-oscyank', {branch = "main"})
	use("potamides/pantran.nvim")
	use('alx741/vinfo')
	use('github/copilot.vim')

	-- objects
	use('michaeljsmith/vim-indent-object')

	-- completion
	use('neovim/nvim-lspconfig')
	use('hrsh7th/nvim-cmp')
	use('hrsh7th/cmp-nvim-lua')
	use('hrsh7th/cmp-nvim-lsp')
	use('hrsh7th/cmp-buffer')
	use('hrsh7th/cmp-path')
	use('hrsh7th/cmp-cmdline')
	use('hrsh7th/cmp-nvim-lsp-signature-help')
	use('alvan/vim-closetag')

	use('mfussenegger/nvim-dap')

	-- java
	use('mfussenegger/nvim-jdtls')

	-- snippets
	use('L3MON4D3/LuaSnip')
	use('saadparwaiz1/cmp_luasnip')

	-- notes
	use('renerocksai/telekasten.nvim')
end)
