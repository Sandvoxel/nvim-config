return {
  "kylechui/nvim-surround",
  version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        normal = "gs", -- instead of 'ys'
        visual = "S",
        delete = "ds",
        change = "cs",
      },
    })
  end,
}
