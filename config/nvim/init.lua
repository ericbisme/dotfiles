require("config.lazy")

-- Basic settings
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

vim.opt.shortmess:remove('c')  -- smc=0 equivalent
vim.opt.number = true
vim.opt.mouse = ""

-- Indentation
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.smartindent = true

-- Folding & visuals
vim.opt.foldenable = false
vim.opt.colorcolumn = "81"
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 5

vim.diagnostic.config({
  float = {
    source = true,
    format = function(diagnostic)
      return string.format("%s [%s]", diagnostic.message, diagnostic.code or diagnostic.source)
    end,
  },
  virtual_text = {
    prefix = '●', -- or ">>", "⚠️", etc.
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
