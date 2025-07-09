return {
  "nvim-pack/nvim-spectre",
  cmd = "Spectre",
  keys = {
    {
      "<leader>S",
      function()
        require("spectre").toggle()
      end,
      desc = "Toggle Spectre",
    },
    {
      "<leader>sw",
      function()
        require("spectre").open_visual({ select_word = true })
      end,
      desc = "Search word under cursor",
    },
    {
      "<leader>sp",
      function()
        require("spectre").open_file_search({ select_word = true })
      end,
      desc = "Search current file",
    },
  },
  opts = {
    live_update = true, -- shows replacement live in preview
    is_insert_mode = false,
    line_sep_start = "╭──────────────────────────────────────────",
    result_padding = "│ ",
    line_sep = "╰──────────────────────────────────────────",
    highlight = {
      ui = "String",
      search = "DiffChange",
      replace = "DiffDelete",
    },
  },
}
