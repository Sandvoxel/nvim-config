local function goto_definition(interactive_split)
  vim.lsp.buf.definition({
    on_list = function(options)
      local seen = {}
      local unique_items = {}

      for _, item in ipairs(options.items) do
        local key = string.format("%s:%d:%d", item.filename, item.lnum, item.col)
        if not seen[key] then
          seen[key] = true
          table.insert(unique_items, item)
        end
      end

      if #unique_items == 0 then
        print("No definition found")
        return
      end

      local function jump_to(item, split_cmd)
        vim.cmd(string.format("%s %s", split_cmd, vim.fn.fnameescape(item.filename)))
        vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
      end

      if interactive_split then
        vim.cmd("echo 'Split direction (h/j/k/l): '")
        local char = vim.fn.nr2char(vim.fn.getchar())

        local dir_map = {
          h = "leftabove vsplit",
          l = "rightbelow vsplit",
          k = "aboveleft split",
          j = "belowright split",
        }

        local split_cmd = dir_map[char]
        if split_cmd then
          jump_to(unique_items[1], split_cmd)
        else
          print("Invalid direction key: " .. char)
        end
      else
        if #unique_items == 1 then
          jump_to(unique_items[1], "edit")
        else
          vim.fn.setqflist({}, " ", {
            title = options.title or "Definitions",
            items = unique_items,
          })
          vim.cmd("copen")
        end
      end
    end,
  })
end
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
    init = function() end,
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
    lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      lspconfig.lua_ls.setup({})
      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      --

      vim.keymap.set("n", "gd", function()
        goto_definition(false)
      end, { desc = "Go to definition (smart jump or quickfix)" })

      vim.keymap.set("n", "gD", function()
        goto_definition(true)
      end, { desc = "Go to definition with hjkl split prompt" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    end,
  },
}
