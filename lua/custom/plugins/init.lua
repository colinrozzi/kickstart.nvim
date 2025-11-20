-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Snacks.nvim - Modern plugin collection including file explorer
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Enable the modules you want
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      
      -- Explorer configuration
      explorer = {
        replace_netrw = true, -- Replace netrw with snacks explorer
        trash = true, -- Use system trash when deleting files
      },
      
      -- Picker configuration for explorer
      picker = {
        sources = {
          explorer = {
            -- Explorer picker settings
            git_status = true, -- Show git status indicators
            diagnostics = true, -- Show diagnostic indicators
          },
        },
      },
    },
    keys = {
      { "\\", function() Snacks.explorer.open() end, desc = "Explorer" },
      { "<leader>e", function() Snacks.explorer.open() end, desc = "[E]xplorer" },
      { "<leader>E", function() Snacks.explorer.reveal() end, desc = "[E]xplorer Reveal" },
    },
  },
}
