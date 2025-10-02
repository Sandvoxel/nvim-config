return {
  {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
      require("crates").setup()
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    init = function()
      local rustacean = vim.g.rustaceanvim or {}
      rustacean.server = rustacean.server or {}
      -- Silence rust-analyzer "took too long" status pings unless user overrides it.
      if rustacean.server.status_notify_level == nil then
        rustacean.server.status_notify_level = false
      end

      local caps = require("cmp_nvim_lsp").default_capabilities()
      caps.textDocument.completion.completionItem.insertReplaceSupport = false
      rustacean.server.capabilities = caps

      vim.g.rustaceanvim = rustacean
    end,
  },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function apply_keymaps()
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
      end

      if vim.lsp and vim.lsp.config then
        local function setup(server, opts)
          opts = opts or {}
          if capabilities then
            opts.capabilities = opts.capabilities and vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities)
              or capabilities
          end
          vim.lsp.config(server, opts)
          vim.lsp.enable(server)
        end

        setup("clangd")
        setup("lua_ls")
      else
        local lspconfig = require("lspconfig")
        lspconfig.clangd.setup({ capabilities = capabilities })
        lspconfig.lua_ls.setup({ capabilities = capabilities })
      end

      apply_keymaps()
    end,
  },
}
