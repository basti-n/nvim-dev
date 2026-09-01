return {
  'folke/twilight.nvim',
  opts = {},
  config = function()
    vim.keymap.set('n', '<leader>tw', ':Twilight<CR>', {
      desc = 'Toggle Twilight',
    })
  end,
}
