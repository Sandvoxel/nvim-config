return {
  "luc-tielen/telescope_hoogle",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("telescope").load_extension("hoogle")
  end,
  ft = { "haskell", "lhaskell", "cabal" }, -- load only for Haskell filetypes
}
