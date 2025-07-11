return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function() end,
  },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "rust_analyzer", "lua_ls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      lspconfig.lua_ls.setup({})
      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    end,
  },
}
