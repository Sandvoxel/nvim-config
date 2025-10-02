return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = 15,
    open_mapping = [[<C-\>]],
    direction = "float",
    shade_terminals = true,
    float_opts = {
      border = "curved",
    },
    -- You can still use these callbacks if you want to modify behavior when the terminal opens/closes
    on_open = function(_)
      -- Optional: save the current window to return to after the terminal closes
      vim.b.toggleterm_prev_win = vim.api.nvim_get_current_win()
    end,
    on_close = function()
      -- Return to previous window if stored
      local prev_win = vim.b.toggleterm_prev_win
      if prev_win and vim.api.nvim_win_is_valid(prev_win) then
        vim.api.nvim_set_current_win(prev_win)
      end
    end,
  },
}
