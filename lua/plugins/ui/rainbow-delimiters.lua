return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
      },
      query = {
        [""] = "rainbow-delimiters",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }

    -- Optional: Customize colors manually
    local highlight = vim.api.nvim_set_hl
    highlight(0, "RainbowDelimiterRed", { fg = "#fb4934" }) -- Gruvbox red
    highlight(0, "RainbowDelimiterYellow", { fg = "#fabd2f" }) -- Gruvbox yellow
    highlight(0, "RainbowDelimiterBlue", { fg = "#83a598" }) -- Gruvbox blue
    highlight(0, "RainbowDelimiterOrange", { fg = "#fe8019" }) -- Gruvbox orange
    highlight(0, "RainbowDelimiterGreen", { fg = "#b8bb26" }) -- Gruvbox green
    highlight(0, "RainbowDelimiterViolet", { fg = "#d3869b" }) -- Gruvbox purple
    highlight(0, "RainbowDelimiterCyan", { fg = "#8ec07c" }) -- Gruvbox aqua
  end,
}
