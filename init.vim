if &compatible
  set nocompatible  " Be iMproved
endif

""""""""""""""""""""""""""""""""""""""""
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

" Trouble
Plug 'folke/lsp-colors.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

" Autoformat
Plug 'Chiel92/vim-autoformat'

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

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""
"""          LSP and nvim-cmp
set completeopt=menu,menuone,noselect

lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.ltex.setup{}
require'lspconfig'.bashls.setup{}

-- Function signatures.
cfg = {}  -- add you config here
-- require "lsp_signature".setup(cfg)
require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  }
})

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
local function buf_set_keymap(...)

vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<C-/>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
end

  -- Setup nvim-cmp.
 local cmp = require'cmp'
  local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
 end

local luasnip = require("luasnip")
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
    cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
        elseif has_words_before() then
    cmp.complete()
        else
    fallback()
        end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
    cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
        else
    fallback()
        end
    end, { "i", "s" }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "clangd", "rust_analyzer", "ltex", "bashls"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- debounce_text_changes = 150,
      capabilities = capabilities
      }
    }
end
EOF

"""""""""""""""""""""""""""""""""""""""""""
"    Other plugin configurations

set termguicolors
let g:airline_theme='gruvbox'
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

" Airline
let g:airline_powerline_fonts = 0
let g:airline_skip_empty_sections = 1
let g:airline_detect_spelllang = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" Autoformat
au BufWrite * :Autoformat
" Disable formatting for Tex, txt and shell scripts.
autocmd FileType vim,tex,dockerfile,sh let b:autoformat_autoindent=0

" More aggressive python formatting.
let g:formatdef_autopep8 = "'autopep8 - --aggressive --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['autopep8']

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Troule
lua << EOF
require("trouble").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  }
EOF
nnoremap <leader>t <cmd>TroubleToggle document_diagnostics<CR>
" Git gutter
hi GitGutterAdd    ctermfg=2
hi GitGutterChange ctermfg=3
hi GitGutterDelete ctermfg=1

" Autoformat
let g:python3_host_prog="/usr/bin/python3"

""""""""""""""""""""""""""""""""""""""""""""
"          General config

set relativenumber

set number
set updatetime=200
set splitright

" set tags=./tags,tags;

" Required:
filetype plugin indent on
syntax enable
set hidden
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set scrolloff=20

set spell spelllang=en_us
set inccommand=split

" Better searching
set ignorecase
set smartcase

highlight StatusLine          cterm=bold    ctermfg=16 ctermbg=13
highlight StatusLineNC        cterm=inverse ctermfg=16 ctermbg=13

set cursorline
set clipboard=unnamedplus

" Longer timout for leader key
set timeoutlen=2000

""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymappings

" Disable arrow keys in normal mode.
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" noremap <F8> <ESC>:!ctags -R
nnoremap <F3> <ESC>:vert new<CR><C-o>:term python3<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"nnoremap <C-m> <ESC>:Marks<CR>
nnoremap <C-w><C-n> <ESC>:vert new<CR>
nnoremap <C-s> :update<CR>
inoremap <C-s> <ESC>:update<CR>i
noremap <C-w>n <esc>:vnew<cr>
noremap <F4> :Autoformat<CR>

" Improve search hl behaviour
nnoremap * :keepjumps normal! mi*`i<CR>

" Why does this have to be here? I don't know, if you place it further up it
" doesn't work...
hi SignColumn cterm=NONE ctermbg=0 ctermfg=0
