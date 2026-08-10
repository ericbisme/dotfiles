return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
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

      -- Lua
      require('neodev').setup({})
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
      vim.lsp.config('eslint', {
        settings = {
          experimental = { useFlatConfig = true },
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
