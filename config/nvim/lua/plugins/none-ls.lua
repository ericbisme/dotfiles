return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",

    -- provides shellcheck sources again (diagnostics + code_actions)
    "gbprod/none-ls-shellcheck.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local b = null_ls.builtins

    local sources = {}

    local function req(mod)
      local ok, m = pcall(require, mod)
      return ok and m or nil
    end

    -- ESLint diagnostics and code actions come from the eslint language server
    -- (see lsp.lua), not from none-ls, so none-ls-extras is not needed here.

    -- --------
    -- Formatters (these are still normal builtins)
    -- --------
    if b.formatting.prettier then
      table.insert(sources, b.formatting.prettier)
    end
    if b.formatting.terraform_fmt then
      table.insert(sources, b.formatting.terraform_fmt)
    end
    if b.formatting.shfmt then
      table.insert(sources, b.formatting.shfmt)
    end

    -- --------
    -- Shellcheck (from gbprod plugin, not core builtins)
    -- --------
    local shellcheck_diag = req("none-ls-shellcheck.diagnostics")
    local shellcheck_actions = req("none-ls-shellcheck.code_actions")

    if shellcheck_diag then
      table.insert(sources, shellcheck_diag)
    end
    if shellcheck_actions then
      table.insert(sources, shellcheck_actions)
    end

    -- --------
    -- Other linters (keep as-is; only add if your install actually has them)
    -- --------
    if b.diagnostics.yamllint then
      table.insert(sources, b.diagnostics.yamllint)
    end

    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client:supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              -- vim.lsp.buf.format({ bufnr = bufnr })
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c) return c.name == "null-ls" end,
              })
            end,
          })
        end
      end,
    })
  end,
}
