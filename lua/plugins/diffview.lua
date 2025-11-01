return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('diffview').setup {
      diff_binaries = false,
      enhanced_diff_hl = false,
      use_icons = true,
      icons = {
        folder_closed = '',
        folder_open = '',
      },
      signs = {
        fold_closed = '',
        fold_open = '',
        done = '✓',
      },
      file_panel = {
        listing_style = 'tree',
        tree_options = {
          flatten_dirs = true,
          folder_statuses = 'only_folded',
        },
        win_config = {
          position = 'left',
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = 'combined',
            },
            multi_file = {
              diff_merges = 'first-parent',
            },
          },
        },
        win_config = {
          position = 'bottom',
          height = 16,
        },
      },
    }

    -- Keymaps
    local default_opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewOpen<cr>', vim.tbl_extend('force', default_opts, { desc = 'Open Diffview' }))
    vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<cr>', vim.tbl_extend('force', default_opts, { desc = 'Close Diffview' }))
    vim.keymap.set('n', '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', vim.tbl_extend('force', default_opts, { desc = 'File History (current)' }))
    vim.keymap.set('n', '<leader>dH', '<cmd>DiffviewFileHistory<cr>', vim.tbl_extend('force', default_opts, { desc = 'File History (all)' }))
  end,
}
