require('install_plugins')

--          LSP and nvim-cmp
vim.opt.completeopt={'menu','menuone','noselect'}

require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
--- require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.ltex.setup{}
require'lspconfig'.bashls.setup{}

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)

    -- Function signatures.
    cfg = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      },
      toggle_key = '<leader> z',
      select_signature_key = '<leader> Z'
    }
    require "lsp_signature".setup(cfg, bufnr)

    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  buf_set_keymap('', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', opts)
  buf_set_keymap('', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
  buf_set_keymap('', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
  buf_set_keymap('', '<leader>fs', '<cmd>lua require("telescope.builtin").grep_string()<cr>', opts)
  buf_set_keymap('', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)

  buf_set_keymap('', '<leader>t',' <cmd>TroubleToggle document_diagnostics<CR>', opts)

  buf_set_keymap('', '<Up>', '<Nop>', opts)
  buf_set_keymap('', '<Down>', '<Nop>', opts)
  buf_set_keymap('', '<Left>', '<Nop>', opts)
  buf_set_keymap('', '<Right>', '<Nop>', opts)

  buf_set_keymap('', '<F3>',' <ESC>:vert new<CR><C-o>:term python3<CR>', opts)
  buf_set_keymap('', '<C-h>',' <C-w>h', opts)
  buf_set_keymap('',  '<C-j>',' <C-w>j', opts)
  buf_set_keymap('',  '<C-k>',' <C-w>k', opts)
  buf_set_keymap('',  '<C-l>',' <C-w>l', opts)
  buf_set_keymap('',  '<C-w><C-n>',' <ESC>:vert new<CR>', opts)
  buf_set_keymap('',  '<C-s>',' :update<CR>', opts)
  buf_set_keymap('', '<C-w>n',' <esc>:vnew<cr>', opts)
  buf_set_keymap('', '<F4>',' :Autoformat<CR>', opts)
  vim.cmd [[inoremap <C-s>',' <ESC>:update<CR>i]]
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

require("rust-tools").setup({
  server={
    on_attach=on_attach,
    standalone = true,
  },
  flags={
    capabilities = capabilities
  }
})

require("trouble").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
  )
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "clangd", "ltex", "bashls", "sumneko_lua"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- debounce_text_changes = 150,
      capabilities = capabilities
    }
  }
end

-- Grubox them
vim.opt.termguicolors = true
vim.g.airline_theme = 'gruvbox'
vim.cmd [[colorscheme gruvbox]]
vim.g.gruvbox_contrast_dark = 'medium'

-- Airline
vim.g.airline_powerline_fonts = 0
vim.g.airline_skip_empty_sections = 1
vim.g.airline_detect_spelllang = 0
vim.g.airline_detect_spell = 0
vim.cmd [[let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]']]

-- Autoformat
vim.cmd [[au BufWrite * :Autoformat]]
vim.g.autoformat_autoindent = 0
vim.g.autoformat_retab  = 0

-- Use more aggressive python formatting.
vim.g.formatdef_autopep8 = "'autopep9 - --aggressive --range '.a:firstline.' '.a:lastline"
vim.cmd [[let g:formatters_python = ['autopep8'] ]]
vim.cmd [[ let g:formatters_lua = ['luafmt'] ]]

-- git gutter
vim.cmd([[
  hi GitGutterAdd    ctermfg=2
  hi GitGutterChange ctermfg=3
  hi GitGutterDelete ctermfg=1
]])

-- general config
vim.o.relativenumber = true
vim.onumber = true
vim.o.updatetime=200
vim.o.splitright = true

-- Autoformat
vim.g.python3_host_prog = '/usr/bin/python3'


vim.cmd [[filetype plugin indent on]]
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

vim.cmd([[
  highlight StatusLine          cterm=bold    ctermfg=16 ctermbg=13
  highlight StatusLineNC        cterm=inverse ctermfg=16 ctermbg=13
]])

vim.cmd[[ nnoremap * :keepjumps normal! mi*`i<CR> ]]
vim.cmd[[ hi SignColumn cterm=NONE ctermbg=0 ctermfg=0 ]]
