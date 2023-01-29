vim.wo.number = true

local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'ryanoasis/vim-devicons'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'glacambre/firenvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

vim.call('plug#end')

vim.cmd.colorscheme('atom')

require("mason").setup()
