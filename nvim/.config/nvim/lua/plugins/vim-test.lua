return {
  {
    "vim-test/vim-test",
    dependencies = { "preservim/vimux" },
    keys = {
      { "<leader>T", "<cmd>TestFile<cr>", desc = "Test file" },
      { "<leader>a", "<cmd>TestSuite<cr>", desc = "Test suite" },
      { "<leader>l", "<cmd>TestLast<cr>", desc = "Test last" },
      { "<leader>g", "<cmd>TestVisit<cr>", desc = "Test visit" },
    },
    config = function()
      vim.g["test#strategy"] = "vimux"
    end,
  },
}
