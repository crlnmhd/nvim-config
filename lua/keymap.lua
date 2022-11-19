local keymap = {}

local implementaion= {}

function keymap.set_global(mode, lhs, rhs, opts)
  local options = implementaion.get_options(opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function keymap.set_for_buf(bufnr, mode, lhs, rhs, opts)
  local options = implementaion.get_options(opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

function implementaion.get_options(opts)
  local options = {noremap = true}
  if opts then
    vim.tbl_extend('force', options, opts)
  end
  return options
end


return keymap
