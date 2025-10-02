return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>ft",
      function()
        require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
      end,
      desc = "Toggle File Tree",
    },
  },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
    })
  end,
}
