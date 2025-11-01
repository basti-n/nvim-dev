return {
  -- 🧠 Sidekick
  {
    'folke/sidekick.nvim',
    opts = {
      copilot = {
        handle_lsp_status = true,
      },
      cli = {
        mux = {
          -- backend = 'tmux',
          enabled = true,
        },
      },
    },
    keys = {
      -- Remember: <c-q> to go into normal mode in copilot CLI
      {
        '<c-j>',
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          local nes_jump_or_apply = require('sidekick').nes_jump_or_apply
          if not nes_jump_or_apply() then
            return vim.lsp.completion.get { noinline = true }
          end
          return nes_jump_or_apply()
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      {
        '<c-.>',
        function()
          require('sidekick.cli').toggle { name = 'copilot', focus = true }
        end,
        desc = 'Sidekick Toggle',
        mode = { 'n', 't', 'i', 'x' },
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle { name = 'copilot', focus = true }
        end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>as',
        function()
          require('sidekick.cli').select { name = 'copilot' }
        end,
        desc = 'Select CLI',
      },
      {
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        desc = 'Detach CLI Session',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send { msg = '{this}' }
        end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send { msg = '{file}' }
        end,
        desc = 'Send File',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send { msg = '{selection}' }
        end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
      {
        '<leader>aw',
        function()
          -- Find the sidekick CLI window
          local win = nil
          for _, w in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(w)
            local ft = vim.bo[buf].filetype
            if ft == 'sidekick_terminal' then
              win = w
              break
            end
          end

          if win and vim.api.nvim_win_is_valid(win) then
            local current_width = vim.api.nvim_win_get_width(win)
            local full_width = vim.o.columns
            if current_width < full_width * 0.9 then
              vim.api.nvim_win_set_width(win, full_width)
            else
              vim.api.nvim_win_set_width(win, math.floor(full_width * 0.5))
            end
          end
        end,
        desc = 'Toggle Sidekick Width',
        mode = { 'n', 't' },
      },
    },
  },

  -- ⚡ Blink CMP
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = {
        ['<C-j>'] = {
          'snippet_forward',
          function()
            return require('sidekick').nes_jump_or_apply()
          end,
          function()
            return vim.lsp.completion.get { noinline = true }
          end,
          'fallback',
        },
      },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false } },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },

  -- 🤖 Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false }, -- disable old popup UI
        panel = { enabled = false },
      }
    end,
  },

  -- (optional) Copilot LSP integration for Sidekick NES
  {
    'copilotlsp-nvim/copilot-lsp',
    dependencies = { 'zbirenbaum/copilot.lua' },
  },
}
