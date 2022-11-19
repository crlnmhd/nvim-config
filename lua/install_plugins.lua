-- keep using Plugged for now

vim.cmd([[
" Plugg
call plug#begin('~/.config/nvim/plugged')

" Git gutter
Plug 'airblade/vim-gitgutter'

" Fugitiv
Plug 'https://github.com/tpope/vim-fugitive.git'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Gruvbox theme
Plug 'morhetz/gruvbox'

" lspconfig
Plug 'neovim/nvim-lspconfig'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Autoformat
Plug 'vim-autoformat/vim-autoformat'

" nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Function signatures
Plug 'ray-x/lsp_signature.nvim'
" luasnip
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'


" Rust-tools for inlay hints
Plug 'simrat39/rust-tools.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
call plug#end()

]])
