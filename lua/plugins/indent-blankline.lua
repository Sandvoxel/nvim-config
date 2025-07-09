return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  opts = {
    indent = {
      char = "╎", -- Your requested character
    },
    scope = {
      enabled = true, -- highlight current indent scope
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        "help",
        "lazy",
        "dashboard",
        "NvimTree",
        "neo-tree",
        "Trouble",
        "alpha",
        "terminal",
      },
      buftypes = { "terminal", "nofile" },
    },
  },
}
