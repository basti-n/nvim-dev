return {
  -- 🤖 OpenCode
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      local opencode = require 'opencode'

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
        provider = {
          enabled = 'tmux',
        },
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Keymaps matching sidekick functionality as closely as possible
      vim.keymap.set({ 'n', 't' }, '<leader>aa', opencode.toggle, { desc = 'Toggle OpenCode' })

      vim.keymap.set({ 'n', 'x' }, '<leader>ask', function()
        opencode.ask('@this: ', { submit = true })
      end, { desc = 'Ask OpenCode' })

      vim.keymap.set('n', '<leader>as', function()
        opencode.command 'session.list'
      end, { desc = 'Select OpenCode Session' })

      vim.keymap.set({ 'n', 'x' }, '<leader>ath', function()
        opencode.prompt '@this'
      end, { desc = 'Send This to OpenCode' })

      vim.keymap.set('n', '<leader>af', function()
        opencode.prompt '@buffer'
      end, { desc = 'Send File to OpenCode' })

      vim.keymap.set('x', '<leader>av', function()
        opencode.prompt '@this'
      end, { desc = 'Send Visual Selection to OpenCode' })

      vim.keymap.set({ 'n', 'x' }, '<leader>ap', opencode.select, { desc = 'OpenCode Select Action' })

      -- Additional OpenCode-specific commands
      vim.keymap.set('n', '<S-C-u>', function()
        opencode.command 'session.half.page.up'
      end, { desc = 'OpenCode half page up' })

      vim.keymap.set('n', '<S-C-d>', function()
        opencode.command 'session.half.page.down'
      end, { desc = 'OpenCode half page down' })
    end,
  },

  -- ⚡ Blink CMP
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = {
        ['<C-j>'] = { 'snippet_forward', 'fallback' },
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

  -- (optional) Copilot LSP integration
  {
    'copilotlsp-nvim/copilot-lsp',
    dependencies = { 'zbirenbaum/copilot.lua' },
  },
}
