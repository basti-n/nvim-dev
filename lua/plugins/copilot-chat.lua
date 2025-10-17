local IS_DEV = false
local utils = require 'core.utils'

local prompts = {
  -- Code related prompts
  Explain = 'Please explain how the following code works.',
  Review = 'Please review the following code and provide suggestions for improvement.',
  Tests = 'Please explain how the selected code works, then generate unit tests for it.',
  TestsOnly = '#buffer Please generate unit tests for the current file (buffer). Use jest. Write describe block for all public functionalities.',
  Refactor = 'Please refactor the following code to improve its clarity and readability.',
  FixCode = 'Please fix the following code to make it work as intended.',
  FixError = 'Please explain the error in the following text and provide a solution.',
  BetterNamings = 'Please provide better names for the following variables and functions.',
  Documentation = 'Please provide documentation for the following code.',
  SwaggerApiDocs = 'Please provide documentation for the following API using Swagger.',
  SwaggerJsDocs = 'Please write JSDoc for the following API using Swagger.',
  -- Text related prompts
  Summarize = 'Please summarize the following text.',
  Spelling = 'Please correct any grammar and spelling errors in the following text.',
  Wording = 'Please improve the grammar and wording of the following text.',
  Concise = 'Please rewrite the following text to make it more concise.',
  Research = {
    prompt = 'Follow the instructions from the markdown file:',
    system_prompt = utils.read_file(vim.fn.expand '~/agent/research_codebase.md'),
  },
  Commit = {
    prompt = 'Follow the instructions from the markdown file:',
    system_prompt = utils.read_file(vim.fn.expand '~/agent/commit.md'),
  },
  CreatePlan = {
    prompt = 'Follow the instructions from the markdown file:',
    system_prompt = utils.read_file(vim.fn.expand '~/agent/create_plan.md'),
  },
  ImplementPlan = {
    prompt = 'Follow the instructions from the markdown file:',
    system_prompt = utils.read_file(vim.fn.expand '~/agent/implement_plan.md'),
  },
}

return {
  {
    'folke/which-key.nvim',
    optional = true,
    opts = {
      spec = {
        { '<leader>a', group = 'ai', mode = { 'n', 'v' } },
      },
    },
  },
  {
    -- [NOTE]: brew install lynx if you want browser terminal
    dir = IS_DEV and '~/research/CopilotChat.nvim' or nil,
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    -- version = "v3.7.0",
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    opts = {
      question_header = '## User ',
      answer_header = '## Copilot ',
      error_header = '## Error ',
      prompts = prompts,
      model = 'claude-sonnet-4.5',
      mappings = {
        -- Use tab for completion
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<C-p>',
        },
        -- Close the chat
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        -- Reset the chat buffer
        reset = {
          normal = '<C-x>',
          insert = '<C-x>',
        },
        -- Submit the prompt to Copilot
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        -- Accept the diff
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        -- Show help
        show_help = {
          normal = 'g?',
        },
      },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'

      local hostname = io.popen('hostname'):read('*a'):gsub('%s+', '')
      local user = hostname or vim.env.USER or 'User'
      opts.question_header = '  ' .. user .. ' '
      opts.answer_header = '  Copilot '
      -- Override the git prompts message
      opts.prompts.Commit = {
        prompt = '> #git:staged\n\nWrite commit message with commitizen convention. Write clear, informative commit messages that explain the "what" and "why" behind changes, not just the "how".',
      }

      chat.setup(opts)

      local select = require 'CopilotChat.select'
      vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = '*', range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command('CopilotChatInline', function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = 'float',
            relative = 'cursor',
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = '*', range = true })

      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command('CopilotChatBuffer', function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = '*', range = true })

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'copilot-chat',
        callback = function()
          vim.keymap.set({ 'n', 'i' }, '<leader>pf', function()
            require('telescope.builtin').find_files {
              attach_mappings = function(_, map)
                local actions = require 'telescope.actions'
                local action_state = require 'telescope.actions.state'

                local function insert_path(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  local rel_path = vim.fn.fnamemodify(selection.path, ':.')
                  vim.api.nvim_put({ rel_path }, '', false, true)
                end

                map('i', '<C-p>', insert_path)
                map('n', '<C-p>', insert_path)
                return true
              end,
            }
          end, { buffer = true })
        end,
      })

      -- Store initial width for toggling
      local initial_width = 0.5
      local is_full_width = false

      -- Toggle between full width and initial width
      local function toggle_width()
        if is_full_width then
          -- Go back to initial split width
          chat.config.window.width = initial_width
          is_full_width = false
        else
          -- Go to full width
          chat.config.window.width = 1.0
          is_full_width = true
        end
        -- Close and reopen to apply new width
        chat.close()
        chat.open()
      end

      -- Add the width toggle keybinding
      vim.keymap.set({ 'n', 'v' }, '<leader>aw', toggle_width, { desc = 'CopilotChat - Toggle width' })
    end,
    keys = {
      -- Show prompts actions
      {
        '<leader>ap',
        function()
          require('CopilotChat').select_prompt {
            context = {
              'buffers',
            },
          }
        end,
        desc = 'CopilotChat - Prompt actions',
      },
      {
        '<leader>ap',
        function()
          require('CopilotChat').select_prompt()
        end,
        mode = 'x',
        desc = 'CopilotChat - Prompt actions',
      },
      -- Code related commands
      { '<leader>ae', '<cmd>CopilotChatExplain#buffer<cr>', desc = 'CopilotChat - Explain code' },
      { '<leader>aT', '<cmd>CopilotChatTests#buffer<cr>', desc = 'CopilotChat - Generate tests' },
      { '<leader>ar', '<cmd>CopilotChatReview#buffer<cr>', desc = 'CopilotChat - Review code' },
      { '<leader>aR', '<cmd>CopilotChatRefactor#buffer<cr>', desc = 'CopilotChat - Refactor code' },
      { '<leader>an', '<cmd>CopilotChatBetterNamings#buffer<cr>', desc = 'CopilotChat - Better Naming' },
      -- selected prompts
      { '<C-a>s', '<cmd>CopilotChatVisual#selection<cr>', desc = 'CopilotChat - Context: Selection', mode = 'v' },
      { '<C-a>e', '<cmd>CopilotChatExplain<cr>', desc = 'CopilotChat - Explain code', mode = 'v' },
      { '<C-a>r', '<cmd>CopilotChatReview#selection<cr>', desc = 'CopilotChat - Review code', mode = 'v' },
      { '<C-a>R', '<cmd>CopilotChatRefactor#selection<cr>', desc = 'CopilotChat - Refactor code', mode = 'v' },
      { '<C-a>n', '<cmd>CopilotChatBetterNamings#selection<cr>', desc = 'CopilotChat - Better Naming', mode = 'v' },
      -- Chat with Copilot in visual mode
      {
        '<leader>av',
        ':CopilotChatVisual',
        mode = 'x',
        desc = 'CopilotChat - Open in vertical split',
      },
      {
        '<leader>ax',
        ':CopilotChatInline',
        mode = 'x',
        desc = 'CopilotChat - Inline chat',
      },
      -- Custom input for CopilotChat
      {
        '<leader>ai',
        function()
          local input = vim.fn.input 'Ask Copilot: '
          if input ~= '' then
            vim.cmd('CopilotChat ' .. input)
          end
        end,
        desc = 'CopilotChat - Ask input',
      },
      -- Generate commit message based on the git diff
      {
        '<leader>am',
        '<cmd>CopilotChatCommit<cr>',
        desc = 'CopilotChat - Generate commit message for all changes',
      },
      {
        '<leader>aq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, {
              selection = require('CopilotChat.select').buffer,
            })
          end
        end,
        desc = 'CopilotChat - Quick chat',
      },
      -- Fix the issue with diagnostic
      { '<leader>af', '<cmd>CopilotChatFixError<cr>', desc = 'CopilotChat - Fix Diagnostic' },
      -- Clear buffer and chat history
      { '<leader>al', '<cmd>CopilotChatReset<cr>', desc = 'CopilotChat - Clear buffer and chat history' },
      -- Toggle Copilot Chat Vsplit
      { '<leader>av', '<cmd>CopilotChatToggle<cr>', desc = 'CopilotChat - Toggle' },
      -- Copilot Chat Models
      { '<leader>a?', '<cmd>CopilotChatModels<cr>', desc = 'CopilotChat - Select Models' },
      -- Copilot Chat Agents
      { '<leader>aa', '<cmd>CopilotChatAgents<cr>', desc = 'CopilotChat - Select Agents' },
    },
  },
  {
    'folke/which-key.nvim',
    optional = true,
    opts = {
      spec = {
        { '<leader>gm', group = 'Copilot Chat' },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    optional = true,
    opts = {
      file_types = { 'markdown', 'copilot-chat' },
    },
    ft = { 'markdown', 'copilot-chat' },
  },
}
