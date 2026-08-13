return {
  -- Injects the Neovim runtime into lua_ls, so vim.* completes for real.
  -- Successor to neodev.nvim, which is archived and does not hook the native
  -- vim.lsp.config() path used below.
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    -- BufReadPre fires before FileType, so servers still attach to the first
    -- file opened. cmd keeps :Mason and :LspInfo usable with no file loaded.
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'Mason', 'LspInfo' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()

      ----------------------------------------------------------------------
      -- 🔕 Filter TypeScript suggestion diagnostic TS80001 (Neovim 0.11+)
      -- "File is a CommonJS module; it may be converted to an ES module."
      ----------------------------------------------------------------------
      do
        local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]

        vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
          local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)

          if client and client.name == "ts_ls" and result and result.diagnostics then
            result.diagnostics = vim.tbl_filter(function(d)
              return d.code ~= 80001
            end, result.diagnostics)
          end

          return orig(err, result, ctx, config)
        end
      end
      ----------------------------------------------------------------------

      require('mason-lspconfig').setup({
        ensure_installed = {
          "bashls",         -- Bash/Zsh
          "eslint",         -- ESLint
          "lua_ls",         -- Lua
          "terraformls",    -- Terraform
          "tflint",         -- Terraform lint
          "ts_ls",          -- JS/TS
          "yamlls",         -- YAML
        },
      })

      -- Lua (runtime library comes from lazydev.nvim above)
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
          },
        },
      })

      -- JavaScript/TypeScript
      vim.lsp.config('ts_ls', {})

      -- Terraform
      vim.lsp.config('terraformls', {})
      vim.lsp.config('tflint', {})

      -- Bash
      vim.lsp.config('bashls', {})

      -- ESLint
      -- Do NOT set experimental.useFlatConfig: it forces flat-config mode
      -- everywhere, so the 14 rojoserve repos still on .eslintrc* fail every
      -- lint request with "Could not find config file". Left unset, the server
      -- detects the format per project. (That flag grew a 1.7GB lsp.log.)
      vim.lsp.config('eslint', {
        settings = {
          format = false, -- since prettier owns formatting
        },
      })

      -- YAML
      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            validate = true,
            hover = true,
            completion = true,
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = "/.github/actions/*",
              ["https://json.schemastore.org/kubernetes.json"] = "/*.k8s.yaml",
            },
          },
        },
      })
    end,
  }
}
