return {
  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- trouble required for >= 10
  { "folke/trouble.nvim", enabled = true },
}
