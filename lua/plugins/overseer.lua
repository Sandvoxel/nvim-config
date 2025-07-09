return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerToggle", "OverseerRun" },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Run Task (Overseer)" },
    { "<leader>oo", "<cmd>OverseerToggle<CR>", desc = "Toggle Task List (Overseer)" },
  },
  config = function()
    require("overseer").setup({
      strategy = {
        "toggleterm",
        direction = "horizontal",
      },
      task_list = {
        direction = "bottom",
        min_height = 15,
        bindings = {
          ["<CR>"] = "run",
        },
      },
    })

    local overseer = require("overseer")

    -- Helper to wrap builders and save before running
    local function with_save(builder)
      return function()
        vim.cmd("update") -- saves current buffer if modified
        return builder()
      end
    end

    overseer.register_template({
      name = "Cargo Run",
      builder = with_save(function()
        return {
          cmd = { "cargo" },
          args = { "run" },
          name = "cargo run",
          components = { "default" },
        }
      end),
      condition = {
        filetype = { "rust" },
      },
    })

    overseer.register_template({
      name = "Cargo Test",
      builder = with_save(function()
        return {
          cmd = { "cargo" },
          args = { "test" },
          name = "cargo test",
          components = { "default" },
        }
      end),
      condition = {
        filetype = { "rust" },
      },
    })
  end,
}
