-- File: lua/utils/term_focus.lua

local M = {
  last_valid_win = nil,
}

function M.save_if_valid()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

  if ft ~= "neo-tree" and ft ~= "OverseerList" and ft ~= "toggleterm" then
    M.last_valid_win = win
  end
end

function M.restore_if_valid()
  local win = M.last_valid_win
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  end
end

return M
