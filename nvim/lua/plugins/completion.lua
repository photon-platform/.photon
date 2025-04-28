-- lua/plugins/completion.lua
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- Load when entering insert mode
  dependencies = {
    -- LSP Source
    { "hrsh7th/cmp-nvim-lsp" }, -- Provides completions from the LSP server [14]

    -- Snippet Source (integrates LuaSnip)
    { "saadparwaiz1/cmp_luasnip" }, -- [11]

    -- Other Sources
    { "hrsh7th/cmp-buffer" }, -- Provides completions from text in current buffer [11, 12]
    { "hrsh7th/cmp-path" },   -- Provides completions for file system paths [11, 12]

    -- Optional: UI enhancement for completion kinds (requires Nerd Font)
    -- { "onsails/lspkind.nvim" }
  },
  config = function()
    -- nvim-cmp configuration (detailed in Section VII) will go here
    -- Inside the config = function() block of lua/plugins/completion.lua

    local cmp = require('cmp')
    local luasnip = require('luasnip') -- Required for LuaSnip integration in mappings
    -- local lspkind = require('lspkind') -- Optional: For icons, requires installation

    cmp.setup({
      -- (1) Snippet Engine Integration
      snippet = {
        -- REQUIRED - Tells nvim-cmp HOW to expand snippets
        expand = function(args)
          -- Use LuaSnip's specific function for expansion [11]
          luasnip.lsp_expand(args.body)
          -- Alternatively, for Neovim 0.10+ native snippets (if not using LuaSnip's advanced features)
          -- vim.snippet.expand(args.body) -- [3]
        end,
      },

      -- (2) Completion Sources
      sources = cmp.config.sources({
        -- Order matters: Sources listed earlier have higher priority
        { name = 'nvim_lsp' },  -- LSP completions [11, 12, 14]
        { name = 'luasnip' },   -- Snippets via LuaSnip [11] (requires cmp_luasnip)
        { name = 'buffer' },    -- Text from the current buffer [11, 12] (requires cmp-buffer)
        { name = 'path' },      -- Filesystem paths [11, 12] (requires cmp-path)
      }, {
        -- Optional: Add a second group for lower priority sources if needed
        -- { name = 'cmdline' }, -- Example for command-line mode
      }),

      -- (3) Key Mappings for Completion Menu Interaction
      mapping = cmp.mapping.preset.insert({
        -- Select next/previous item
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), -- [11, 12]
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), -- [11, 12]

        -- Scroll documentation window
        ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll up [11, 12]
        ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll down [11, 12]

        -- Trigger completion manually
        = cmp.mapping.complete(), -- [12]

        -- Abort completion
        ['<C-e>'] = cmp.mapping.abort(), -- Close completion menu [11]

        -- Confirm selection (Accept completion)
        -- `select = true` means confirm the currently highlighted item even if not explicitly selected by C-n/C-p
        = cmp.mapping.confirm({ select = true }), -- [11, 12]

        -- Integrated Tab behavior: Navigate, Complete, or Jump Snippet
        = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- If completion menu is visible, select the next item
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            -- If cursor is on a snippet trigger or inside a snippet, expand or jump [24] inspired logic
            luasnip.expand_or_jump()
          -- elseif require('nvim-autopairs').autopairs_jumpable() then -- Example integration with autopairs
          --   require('nvim-autopairs').autopairs_jump()
          else
            -- Otherwise, fallback to default Tab behavior (e.g., insert tab character)
            fallback()
          end
        end, { "i", "s" }), -- Apply in insert and select mode (for visual snippets)

        -- Integrated Shift-Tab behavior: Navigate or Jump Snippet Backwards
        = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- If completion menu is visible, select the previous item
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            -- If inside a snippet, jump to the previous placeholder [24] inspired logic
            luasnip.jump(-1)
          else
            -- Otherwise, fallback to default Shift-Tab behavior
            fallback()
          end
        end, { "i", "s" }), -- Apply in insert and select mode
      }),

      -- (4) Optional: Formatting (Appearance Customization)
      formatting = {
        fields = {'kind', 'abbr', 'menu'}, -- Elements to display in the menu
        format = function(entry, vim_item)
          -- Add icons based on completion kind (requires Nerd Font and optional lspkind plugin)
          -- local kind_icon = lspkind.presets.default[vim_item.kind] or '?'
          -- vim_item.kind = string.format('%s %s', kind_icon, vim_item.kind)

          -- Add source name indicator [25]
          vim_item.menu = ({
            nvim_lsp = "",
            luasnip = "",
            buffer = "",
            path = "[Pth]",
          })[entry.source.name] or "[?]"

          -- Optional: Truncate long entries
          -- local max_width = 50
          -- vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, max_width)

          return vim_item
        end,
      },

      -- (5) Optional: Window Appearance
      window = {
        completion = cmp.config.window.bordered(), -- Add borders to completion menu
        documentation = cmp.config.window.bordered(), -- Add borders to documentation window
      },

      -- (6) Optional: Experimental Features
      experimental = {
        ghost_text = true, -- Show completion suggestion inline as faint text [12]
      }
    })

    -- (7) Optional: Setup completion for command-line mode
    -- Example for command-line search '/'
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' } -- Use buffer text for search completion [26]
        -- { name = 'fuzzy_buffer' } -- Or use fuzzy buffer source if installed [15]
      }
    })

    -- Example for command-line commands ':'
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' } -- Use path completion for commands like :e, :w [16, 17]
        -- { name = 'fuzzy_path' } -- Or use fuzzy path source if installed [16]
      }, {
        { name = 'cmdline' } -- Complete built-in commands
      })
    })

    -- End of config = function() block
  end,
}
