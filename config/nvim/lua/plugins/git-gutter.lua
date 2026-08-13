return {
  'airblade/vim-gitgutter',
  -- Gutter signs are meaningless without a buffer, and loading this eagerly
  -- puts a git subprocess on the startup path.
  event = { 'BufReadPost', 'BufNewFile' },
}
