-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use({ 'rose-pine/neovim', as = 'rose-pine' })
	use({ 'sainnhe/gruvbox-material', as = 'gruvbox-low' })
	use({ 'loctvl842/monokai-pro.nvim', as = 'monokai-pro' })
	use({ 'morhetz/gruvbox', as = 'gruvbox' })

	vim.cmd('colorscheme gruvbox')

	use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use ('nvim-treesitter/playground')
	use ('mbbill/undotree')

	use {'VonHeikemen/lsp-zero.nvim',
	branch = 'v2.x',
	requires = {
		-- LSP Support
		{'neovim/nvim-lspconfig'},             -- Required
		{'williamboman/mason.nvim', run = function()
			pcall(vim.cmd, 'MasonUpdate')
		end,
	},
	{'williamboman/mason-lspconfig.nvim'}, -- Optional

	-- Autocompletion
	{'hrsh7th/nvim-cmp'},     -- Required
	{'hrsh7th/cmp-nvim-lsp'}, -- Required
	{'L3MON4D3/LuaSnip'},     -- Required
}
  }

end)
