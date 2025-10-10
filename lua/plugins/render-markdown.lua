return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  opts = {},
  setup = function()
    require('render-markdown').setup {
      completions = { coq = { enabled = true } },
    }
  end,
}
