-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local default_opts = { noremap = true, silent = true }

      local function map(mode, l, r, opts)
        opts = opts or default_opts
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Toggles
      map('n', '<leader>tg', gitsigns.toggle_current_line_blame)
    end,
  },
}
