return {
  -- Inline suggestions are only ever used in insert mode, and loading this
  -- eagerly also spawns the Node agent during startup.
  { 'github/copilot.vim', event = 'InsertEnter' },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    -- The prompt-derived commands (Explain, Review, Fix, ...) are created
    -- dynamically by setup(), so they have to be listed here or they silently
    -- fail to trigger a load.
    cmd = {
      'CopilotChat', 'CopilotChatOpen', 'CopilotChatClose', 'CopilotChatToggle',
      'CopilotChatStop', 'CopilotChatReset', 'CopilotChatSave', 'CopilotChatLoad',
      'CopilotChatPrompts', 'CopilotChatModels',
      'CopilotChatExplain', 'CopilotChatReview', 'CopilotChatFix',
      'CopilotChatOptimize', 'CopilotChatDocs', 'CopilotChatTests', 'CopilotChatCommit',
    },
    opts = {},
  },
}
