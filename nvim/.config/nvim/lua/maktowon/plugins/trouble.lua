return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    { "<leader>bw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
    { "<leader>bd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>bq", "<cmd>Trouble quickfix close<CR>", desc = "Open trouble quickfix list" },
    { "<leader>bl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>bt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
  },
}
