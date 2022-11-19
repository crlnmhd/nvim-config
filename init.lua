require('install_plugins')
require('user_config')
local keymap = require('keymap')

-- lspconfig
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.ltex.setup{}
require'lspconfig'.bashls.setup{}

local opts = keymap.default_opts()
local scilent_opts = keymap.default_scilent_opts()

local nvim_lsp = require('lspconfig')
require "lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "rounded"
    }
  })

local on_attach = function (client, bufnr)
  -- Mappings.
  keymap.set_for_buf(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', scilent_opts)
  keymap.set_for_buf(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', scilent_opts)
  keymap.set_for_buf(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', scilent_opts)
end

keymap.set_global('n', '<space>n', '<cmd>lua vim.diagnostic.goto_next()<CR>', scilent_opts)
keymap.set_global('n', '<space>N', '<cmd>lua vim.diagnostic.goto_prev()<CR>', scilent_opts)
keymap.set_global('', '<space><leader>', '<cmd>lua vim.diagnostic.open_float()<CR>', scilent_opts)

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


-- Telescope
keymap.set_global('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', scilent_opts)
keymap.set_global('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', scilent_opts)
keymap.set_global('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', scilent_opts)
keymap.set_global('n', '<leader>fs', '<cmd>lua require("telescope.builtin").grep_string()<cr>', scilent_opts)
keymap.set_global('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', scilent_opts)

vim.g.python3_host_prog = '/usr/bin/python3'

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
vim.g.formatdef_autopep8 = "'autopep8 - --aggressive --range '.a:firstline.' '.a:lastline"
vim.cmd [[let g:formatters_python = ['autopep8'] ]]
vim.cmd [[let g:formatters_lua = ['luafmt'] ]]

-- git gutter
vim.cmd([[
hi GitGutterAdd    ctermfg=2
hi GitGutterChange ctermfg=3
hi GitGutterDelete ctermfg=1
]])
