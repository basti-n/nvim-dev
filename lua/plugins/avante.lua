return {
  'yetone/avante.nvim',
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = 'Agents.md',
    -- for example
    mode = 'legacy',
    provider = 'copilot',
    providers = {
      copilot = {
        -- endpoint = 'https://api.githubcopilot.com',
        -- proxy = nil,
        -- allow_insecure = false,
        timeout = 10 * 60 * 1000,
        -- extra_request_body = {
        --   temperature = 0,
        --   max_completion_tokens = 1000000,
        -- },
        -- reasoning_effort = 'high',
        model = 'claude-sonnet-4.5',
      },
    },
    windows = {
      width = 30, -- default sidebar width (percentage)
      sidebar_header = {
        enabled = true,
      },
    },
  },
  keys = {
    { '<C-x>', '<cmd>AvanteClear<cr>', desc = 'Avante Clear' },
    { '<C-a>', '<cmd>AvanteToggle<cr>', desc = 'Avante Toggle', mode = { 'n', 'i' } },
    { '<leader>af', '<cmd>AvanteFocus<cr>', desc = 'Avante Focus' },
    {
      '<leader>aw',
      function()
        local avante_config = require 'avante.config'
        local current_width = avante_config.windows.width

        -- Check if avante sidebar is currently open
        local avante_open = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
          if ft == 'Avante' or ft == 'AvanteInput' then
            avante_open = true
            break
          end
        end

        -- Toggle between normal width (30%) and full width (80%)
        if current_width == 30 then
          avante_config.windows.width = 80
        else
          avante_config.windows.width = 30
        end

        -- If avante is open, close and reopen to apply new width
        if avante_open then
          vim.cmd 'AvanteToggle'
          -- Small delay to ensure proper close/reopen
          vim.defer_fn(function()
            vim.cmd 'AvanteToggle'
          end, 50)
        end
      end,
      desc = 'Avante Toggle Sidebar Width',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-mini/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'stevearc/dressing.nvim', -- for input provider dressing
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
