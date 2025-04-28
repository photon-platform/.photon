-- lua/plugins/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy", -- Load after startup, typically triggered by filetype detection
  dependencies = {
    -- Add dependencies like mason.nvim and mason-lspconfig.nvim here if desired for automatic LSP server installation
    -- "williamboman/mason.nvim",
    -- "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Inside the config = function() block of lua/plugins/lspconfig.lua

    local lspconfig = require('lspconfig')

    -- (1) Get capabilities advertised by cmp-nvim-lsp
    -- This is essential for nvim-cmp to work correctly with the LSP server [11, 14]
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- Note: Providing these capabilities overrides Neovim's default omnifunc completion for LSP [14]

    -- (2) Define the on_attach function
    -- This function runs *after* the LSP client successfully attaches to a buffer.
    -- It's the standard place for buffer-local settings and keymaps.[11, 20, 21]
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by characters like '.' or '('
      -- client.server_capabilities.completionProvider.triggerCharacters = { ".", "(" } -- Example, adjust as needed

      print("LSP client '".. client.name.. "' attached to buffer: ".. bufnr.. ". Setting keymaps.")

      -- Use vim.keymap.set for modern keymapping
      local map = vim.keymap.set
      -- Options for LSP keymaps:
      -- noremap = true: Do not recursively map keys
      -- silent = true: Do not echo commands in the command line
      -- buffer = bufnr: Make the keymap local to the current buffer
      local opts = { noremap=true, silent=true, buffer=bufnr }

      -- LSP Actions Keybindings (Normal Mode unless specified)
      -- See :help vim.lsp.buf and :help vim.diagnostic
      map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)       -- Go to Definition [11, 21]
      map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)             -- Show Hover Documentation [11, 21]
      map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)   -- Go to Implementation [11, 21]
      map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)       -- Find References [21]
      map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)     -- Go to Declaration [11, 21]
      map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts) -- Go to Type Definition [21]

      map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)    -- Rename Symbol (requires user input) [21] (uses <F2> there)
      -- Map code actions for both Normal and Visual mode
      map({'n', 'v'}, '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts) -- Show Code Actions [21] (uses <F4> there)

      -- Diagnostics Keybindings (Normal Mode)
      map('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<cr>', opts) -- Show Line Diagnostics in floating window
      map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)      -- Jump to Previous Diagnostic
      map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)      -- Jump to Next Diagnostic
      -- Optional: map('<leader>dl', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts) -- List diagnostics in location list

      -- Formatting (Normal Mode)
      map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts) -- Format Code Asynchronously [21] (uses <F3>/gq there)

      -- Optional: Signature Help (Insert Mode) - Often handled by cmp-nvim-lsp-signature-help if installed
      -- map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts) -- Show Signature Help [21] (uses gs in normal mode there)

    -- Optional: Add workspace symbol search, document symbols etc.
    -- map('n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
    -- map('n', '<leader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)


      -- Optional: Disable specific server capabilities if needed
      -- Example: Prevent pylsp from acting as a formatter if you prefer another tool
      -- if client.name == 'pylsp' then
      --   client.server_capabilities.documentFormattingProvider = false
      --   client.server_capabilities.documentRangeFormattingProvider = false
      -- end
      -- Example: Disable semantic tokens highlighting from the server [21]
      -- client.server_capabilities.semanticTokensProvider = nil
    end

    -- (3) Setup the chosen LSP server(s)
    -- Replace 'pyright' or 'pylsp' with the server you installed.

    -- Example setup for Pyright:
    lspconfig.pyright.setup({
      capabilities = capabilities, -- Pass the cmp capabilities
      on_attach = on_attach,      -- Pass the on_attach function
      settings = {                -- Optional: Pyright-specific settings
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            typeCheckingMode = "basic" -- Options: "off", "basic", "strict"
            -- Add other Pyright settings as needed
          }
        }
      }
      -- root_dir = lspconfig.util.root_pattern("pyproject.toml", ".git") -- Default root detection is usually sufficient
    })

    -- Example setup for python-lsp-server (pylsp):
    lspconfig.pylsp.setup({
      capabilities = capabilities, -- Pass the cmp capabilities
      on_attach = on_attach,      -- Pass the on_attach function
      settings = {                -- Optional: Pylsp-specific settings
        pylsp = {                 -- Note the nested 'pylsp' key [22]
          plugins = {
            -- Configure enabled plugins and their settings
            -- Ensure these match the extras installed with pip install python-lsp-server[...]
            pycodestyle = {
              enabled = true,
              ignore = {'E501'}, -- Example: Ignore line too long
              maxLineLength = 100
            },
            pyflakes = { enabled = true },
            jedi_completion = { enabled = true },
            -- Example: Disable pylint if installed via '[all]' but not desired
            pylint = { enabled = false },
            -- Example: Enable flake8 if installed (requires disabling pycodestyle/pyflakes usually)
            -- flake8 = { enabled = true, ignore = {'E501'}, maxLineLength = 100 },
            -- pycodestyle = { enabled = false }, -- Disable if using flake8
            -- pyflakes = { enabled = false }, -- Disable if using flake8
            -- Configure other plugins like 'black', 'mypy', 'isort' if installed and desired
            black = { enabled = true },
            mypy = { enabled = false }, -- Example: Mypy can be resource intensive
          }
        }
      }
      -- cmd = { 'path/to/pylsp' } -- Specify command path if not in global PATH
    })

    -- Add setups for other language servers here if needed
    -- lspconfig.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach,... })

    -- End of config = function() block
    -- --
  end,
}
