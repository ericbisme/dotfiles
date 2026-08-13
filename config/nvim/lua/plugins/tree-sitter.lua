-- branch = 'main' is the incompatible nvim-treesitter rewrite: it installs
-- parsers but does NOT enable highlighting, and it does not support
-- lazy-loading. Without the config below the plugin is inert - no parsers get
-- installed and every filetype falls back to regex syntax.
--
-- REQUIRES the tree-sitter CLI on PATH to compile parsers:
--   brew install tree-sitter-cli
-- (the `tree-sitter` formula is the library only, not the CLI). Without it,
-- install() fails per-parser with ENOENT and highlighting silently stays off.
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    -- Async, and a no-op once the parsers are present, so it does not block
    -- startup. Expect a one-time compile on first launch after this change.
    require('nvim-treesitter').install({
      'bash', 'diff', 'hcl', 'javascript', 'json', 'lua', 'markdown',
      'markdown_inline', 'terraform', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'bash', 'diff', 'hcl', 'javascript', 'json', 'jsonc', 'lua', 'markdown',
        'sh', 'terraform', 'typescript', 'typescriptreact', 'vim', 'yaml', 'zsh',
      },
      callback = function()
        -- pcall: the parser may not be compiled yet on the first run.
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
