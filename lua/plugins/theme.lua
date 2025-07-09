return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000, -- load before other plugins
  lazy = false, -- load on startup
  opts = {
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      comments = true,
      operators = false,
      folds = true,
    },
    contrast = "hard", -- can be "hard", "soft", or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.cmd("colorscheme gruvbox")
  end,
}
