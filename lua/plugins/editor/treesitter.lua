return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "rust",
        "haskell",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "elixir",
        "heex",
        "javascript",
        "html",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })

    -- apply rainbow local identifier highlighting once treesitter is ready
    local ok, rainbow = pcall(require, "utils.rainbow_locals")
    if ok and rainbow then
      rainbow.setup()
    end
  end,
}
