return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          quit_on_open = true, -- closes tree when file is opened
        },
      },
      -- optional: auto-follow opened file in tree
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
    })
  end,
}
