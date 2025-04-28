-- lua/plugins/snippets.lua
return {
  "L3MON4D3/LuaSnip",
  -- Pinning to a specific major version (e.g., v2) can provide stability [6]
  version = "2.*",
  -- Recommended build step for better regex capabilities via jsregexp [6]
  build = "make install_jsregexp",
  dependencies = {
    -- Snippet collection
    { "rafamadriz/friendly-snippets" } -- Common collection including Python snippets [19]
  },
  config = function()
    -- LuaSnip configuration (detailed in Section VIII) will go here
    -- Inside the config = function() block of lua/plugins/snippets.lua

    local luasnip = require('luasnip')

    -- (1) Optional: Configure LuaSnip Behavior [24, 27]
    luasnip.config.set_config({
      -- Store snippet history (allows jumping back after expansion)
      history = true,

      -- Update snippets more frequently (on text change in insert mode)
      updateevents = "TextChanged,TextChangedI",

      -- Enable autotriggered snippets (snippets that expand immediately without Tab/CR) [24, 28]
      -- Requires snippets to be defined as autosnippets (see LuaSnip docs)
      enable_autosnippets = true,

      -- Optional: Enable visual snippets (select text, press key to wrap with snippet)
      -- store_selection_keys = "<Tab>", -- Key to press after visual selection [24]
    })

    -- (2) Load Snippet Collections
    -- Load snippets from friendly-snippets using the VSCode loader
    -- Using lazy_load() is recommended for better startup performance [19]
    require("luasnip.loaders.from_vscode").lazy_load({
      -- Optional: Specify paths if not default
      -- paths = { "./path/to/friendly-snippets" }
      -- Optional: Exclude certain languages/snippet files [19]
      -- exclude = { "javascript" }
    })

    -- Optional: Unload snippets if needed (e.g., to reload)
    -- require("luasnip.loaders.from_vscode").unload()

    -- (3) Optional: Load Custom User Snippets
    -- If you create snippets in ~/.config/nvim/lua/custom-snippets/python.lua (example path)
    -- require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/custom-snippets"}) -- [24]

    -- (4) Keymaps for Snippet Interaction
    -- IMPORTANT: Snippet expansion and jumping are primarily handled by the <Tab> and <S-Tab>
    -- mappings defined within the nvim-cmp configuration (Section VII).
    -- Those mappings check `luasnip.expand_or_jumpable()` and `luasnip.jumpable()`.

    -- Define separate keymaps ONLY if you want different keys or are not using nvim-cmp integration.
    -- Example standalone mappings (use different keys to avoid conflict with cmp):
    -- vim.keymap.set({"i", "s"}, "<C-j>", function() -- Jump forward placeholder
    --   if luasnip.jumpable(1) then luasnip.jump(1) end
    -- end, {silent = true})
    --
    -- vim.keymap.set({"i", "s"}, "<C-k>", function() -- Jump backward placeholder
    --   if luasnip.jumpable(-1) then luasnip.jump(-1) end
    -- end, {silent = true})
    --
    -- vim.keymap.set("i", "<C-l>", function() -- Manually expand snippet under cursor
    --   if luasnip.expandable() then luasnip.expand() end
    -- end, {silent = true})

    print("LuaSnip configured and snippets loaded.")

    -- End of config = function() block
  end,
  -- LuaSnip should be loaded early enough to be available for cmp
  event = "InsertEnter",
}
