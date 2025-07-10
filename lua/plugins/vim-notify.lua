return {
  "rcarriga/nvim-notify",
  lazy = false,
  opts = {
    background_colour = "#1e1e2e", -- Match this to your theme's background
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
