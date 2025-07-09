return {
   "rcarriga/nvim-notify",
   lazy = false,
   opts = {},
    config = function()
    vim.notify = require("notify")
  end,
}
