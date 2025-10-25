return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    strategies = {
      chat = {
        name = 'copilot',
        model = 'gpt-4.1',
      },
      inline = {
        adapter = 'copilot',
        keymaps = {
          accept_change = {
            modes = { n = 'ct' }, -- Remember this as DiffAccept
          },
          reject_change = {
            modes = { n = 'co' }, -- Remember this as DiffReject
          },
          always_accept = {
            modes = { n = 'cty' }, -- Remember this as DiffYolo
          },
        },
      },
    }, -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = 'DEBUG',
    },
  },
  display = {
    diff = {
      enabled = true,
      provider = 'inline', -- mini_diff|split|inline

      provider_opts = {
        -- Options for inline diff provider
        inline = {
          layout = 'buffer', -- float|buffer - Where to display the diff

          diff_signs = {
            signs = {
              text = '▌', -- Sign text for normal changes
              reject = '✗', -- Sign text for rejected changes in super_diff
              highlight_groups = {
                addition = 'DiagnosticOk',
                deletion = 'DiagnosticError',
                modification = 'DiagnosticWarn',
              },
            },
            -- Super Diff options
            icons = {
              accepted = ' ',
              rejected = ' ',
            },
            colors = {
              accepted = 'DiagnosticOk',
              rejected = 'DiagnosticError',
            },
          },

          opts = {
            context_lines = 3, -- Number of context lines in hunks
            dim = 25, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
            full_width_removed = true, -- Make removed lines span full width
            show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
            show_removed = true, -- Show removed lines as virtual text
          },
        },

        -- Options for the split provider
        split = {
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = 'vertical', -- vertical|horizontal split
          opts = {
            'internal',
            'filler',
            'closeoff',
            'algorithm:histogram', -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
            'indent-heuristic', -- https://blog.k-nut.eu/better-git-diffs
            'followwrap',
            'linematch:120',
          },
        },
      },
    },
  },
}
