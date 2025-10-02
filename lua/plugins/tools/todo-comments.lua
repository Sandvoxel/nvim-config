return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  opts = {
    signs = true, -- show icons in the sign column
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "BUG", "FIXME", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
      PERF = { icon = " ", alt = { "OPTIMIZE", "PERFORMANCE", "OPT" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    },
    gui_style = {
      fg = "bold",
      bg = "none",
    },
    highlight = {
      before = "", -- don't highlight the keyword itself
      keyword = "wide", -- highlight whole keyword
      after = "fg", -- highlight text after keyword
      multiline = true,
      max_line_len = 400,
      comments_only = true,
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS):]], -- regex pattern used for searching
    },
  },
  keys = {
    { "<leader>tt", "<cmd>TodoTelescope<CR>", desc = "TODOs (Telescope)" },
    { "<leader>tq", "<cmd>TodoQuickFix<CR>", desc = "TODOs (QuickFix)" },
    { "<leader>tl", "<cmd>TodoLocList<CR>", desc = "TODOs (Location List)" },
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next TODO comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous TODO comment",
    },
  },
}
