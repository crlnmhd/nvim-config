if &compatible
    set nocompatible  " Be iMproved
endif

""""""""""""""""""""""""""""""""""""""""
" Plugg
call plug#begin('~/.config/nvim/plugged')

" Gutentags.
Plug 'ludovicchabant/vim-gutentags'

" Better highlighting
" Plug 'https://github.com/KeitaNakamura/highlighter.nvim'

" Git gutter
Plug 'airblade/vim-gitgutter'

" Fugitiv
Plug 'https://github.com/tpope/vim-fugitive.git'

" Fromatter
" Plug 'mhartington/formatter.nvim'

" Goyo
"lug 'https://github.com/junegunn/goyo.vim'

" Rust-lang
Plug 'rust-lang/rust.vim'

"Plug 'rhysd/vim-clang-format'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Plug 'tomasiser/vim-code-dark'
Plug 'morhetz/gruvbox' 

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/completion-nvim'

Plug 'folke/lsp-colors.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""
"""          LSP

lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}

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
  end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "clangd"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

""""""""""""""""""""""""""""""""""""""""""""""
"""" 	      Auto completion
" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_enable_auto_popup = 0
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab


"""""""""""""""""""""""""""""""""""""""""""
"	   Other plugin configurations

set termguicolors 
let g:airline_theme='gruvbox'
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

" Airline
let g:airline_powerline_fonts = 0
let g:airline_skip_empty_sections = 1
let g:airline_detect_spelllang = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" Telescope 
" Find files using Telescope command-line sugar.
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Troule 
lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
nnoremap <leader>t <cmd>TroubleToggle<CR>


" Gutentags
let g:gutentags_ctags_extra_args = ['tags=./tags,tags']
let g:gutentags_cache_dir = expand('~/.config/nvim/tag_files')
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \] 

" Git gutter
hi GitGutterAdd    ctermfg=2
hi GitGutterChange ctermfg=3
hi GitGutterDelete ctermfg=1


""""""""""""""""""""""""""""""""""""""""""""
"          General config

set relativenumber 

"autocmd vimenter * ++nested 

set number
set updatetime=200
"let g:miramare_enable_italic = 1
"let g:miramare_disable_italic_comment = 1
set splitright
nnoremap cf :<C-u>ClangFormat<CR>


set tags=./tags,tags;
"Temporarily disable arrow keys to learn vim

" Required:
filetype plugin indent on
syntax enable
set hidden
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set scrolloff=5

set spell spelllang=en_us
set inccommand=split

" Better searching 
set ignorecase
set smartcase

highlight StatusLine          cterm=bold    ctermfg=16 ctermbg=13
highlight StatusLineNC        cterm=inverse ctermfg=16 ctermbg=13

set cursorline
set clipboard=unnamedplus


""""""""""""""""""""""""""""""""""""""""""""""""""""
" 		Keymappings

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Leave this traling whitespace alone.
noremap <F8> <ESC>:!ctags -R 
noremap <F4> <ESC>:Format<CR>
nnoremap <F3> <ESC>:vert new<CR><C-o>:term python -i %<CR>a
nnoremap <C-f> <ESC>:GFiles src<CR>
nnoremap <C-f> <ESC>:Files<CR>
nnoremap <C-b> <ESC>:Buffers<CR>
"nnoremap <C-n> <ESC>:Tags<CR>
"nnoremap <C-q> <ESC>:Lines<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"nnoremap <C-m> <ESC>:Marks<CR>
"nnoremap <C-w><C-n> <ESC>:vert new<CR>
nnoremap <C-s> :update<CR>
"nnoremap <Enter> :call ToggleSpell()<CR>
inoremap <C-s> <ESC>:update<CR>i
"tnoremap <C-C> <C-\><C-n>
"
noremap <C-w>n <esc>:vnew<cr>

" Why does this have to be here? I don't know, if you place it further up it
" doesn't work...
hi SignColumn cterm=NONE ctermbg=0 ctermfg=0
