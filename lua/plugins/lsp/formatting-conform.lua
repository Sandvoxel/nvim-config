return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format file (Conform)",
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      rust = { "rustfmt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      haskell = { "fourmolu" }, -- Or use "ormolu" if you prefer
    },
  },
}
