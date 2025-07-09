return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>c", group = "Code Tools" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>s", group = "Search / Replace" },
      { "<leader>t", group = "TODOs" },
      { "<leader>w", group = "Windows" },
      { "<leader>x", group = "Diagnostics / Lists" },
    },
  },
}
