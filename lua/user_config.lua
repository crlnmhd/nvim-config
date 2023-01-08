local keymap = require('keymap')

-- general config
vim.o.relativenumber = true
vim.onumber = true
vim.o.updatetime=200
vim.o.splitright = true


vim.cmd [[filetype plugin indent on]]
vim.o.mouse = ""
vim.o.syntax = 'on'
vim.o.number = true
vim.o.hidden = true
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.shiftwidth=2
vim.o.smarttab = true
vim.o.scrolloff=20
vim.o.spelllang = 'en_us'
vim.o.inccommand = 'split'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.clipboard = 'unnamedplus'
vim.o.timeoutlen=2000

vim.opt.completeopt={'menu','menuone','noselect'}

vim.cmd([[
  highlight StatusLine          cterm=bold    ctermfg=16 ctermbg=13
  highlight StatusLineNC        cterm=inverse ctermfg=16 ctermbg=13
]])

vim.cmd[[ nnoremap * :keepjumps normal! mi*`i<CR> ]]
vim.cmd[[ hi SignColumn cterm=NONE ctermbg=0 ctermfg=0 ]]


-- custom keymap:
keymap.set_global('n', '<Up>', '<Nop>')
keymap.set_global('n', '<Down>', '<Nop>')
keymap.set_global('n', '<Left>', '<Nop>')
keymap.set_global('n', '<Right>', '<Nop>')

keymap.set_global('n', '<F3>',' <ESC>:vert new<CR><C-o>:term python3<CR>')
keymap.set_global('n', '<C-h>',' <C-w>h')
keymap.set_global('n', '<C-j>',' <C-w>j')
keymap.set_global('n', '<C-k>',' <C-w>k')
keymap.set_global('n', '<C-l>',' <C-w>l')
keymap.set_global('n', '<C-w><C-n>',' <ESC>:vert new<CR>')
keymap.set_global('n', '<C-w>n',' <esc>:vnew<cr>')
keymap.set_global('n', '<F4>',' :Autoformat<CR>')

keymap.set_global('n', '<C-s>', ':update<CR>')
keymap.set_global('i', '<C-s>', '<ESC>:update<CR>i')
