return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- { "3rd/image.nvim", opts = {} },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          hijack_netrw_behavior = "open_current",
          follow_current_file = {
            enabled = true,
          },
          open_file = {
            quit_on_open = true, -- closes neo-tree when file opens
            resize_window = true,
            window_picker = {
              enable = false, -- disables window selection prompt
            },
          },
        },
      })
    end,
  },
}
