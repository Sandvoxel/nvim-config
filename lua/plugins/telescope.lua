return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function open_file_in_direction()
        require("telescope.builtin").find_files({
          attach_mappings = function(_, map)
            actions.select_default:replace(function(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              vim.ui.select({ "left", "down", "up", "right" }, {
                prompt = "Open file split direction:",
              }, function(choice)
                if not choice then
                  return
                end

                local cmd = ({
                  left = "leftabove vsplit",
                  right = "rightbelow vsplit",
                  up = "aboveleft split",
                  down = "belowright split",
                })[choice]

                if cmd then
                  vim.cmd(string.format("%s %s", cmd, vim.fn.fnameescape(entry.path)))
                end
              end)
            end)
            return true
          end,
        })
      end

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-n>", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<D-n>", open_file_in_direction, { desc = "Find file with split direction" }) -- On macOS, <D-n> is Cmd+N
      vim.keymap.set("n", "<C-M-n>", open_file_in_direction, { desc = "Find file with split direction" }) -- On some terminals, Ctrl+Shift+N
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
      vim.keymap.set("n", "<leader>fs", function()
        require("telescope.builtin").lsp_workspace_symbols({ query = "" })
      end, { desc = "Search Symbols (LSP)" })
    end,
  },
}
