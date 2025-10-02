return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    {
      "<leader>u",
      "<cmd>UndotreeToggle<CR>",
      desc = "Toggle Undotree",
    },
  },
  init = function()
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_SplitWidth = 40
    vim.g.undotree_DiffAutoOpen = 1
  end,
}
