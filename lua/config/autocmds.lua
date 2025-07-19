-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Create or get an augroup for our autocommands

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    if vim.v.event.operator ~= "p" then
      return
    end

    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]

    -- fallback to cursor if marks are missing
    if start_line == 0 or end_line == 0 then
      start_line = vim.fn.line(".")
      end_line = start_line
    end

    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local supports_format = false
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/rangeFormatting") then
        supports_format = true
        break
      end
    end

    if supports_format then
      vim.lsp.buf.format({
        range = {
          ["start"] = { start_line, 0 },
          ["end"] = { end_line, 0 },
        },
      })
    else
      vim.cmd(string.format("silent! %d,%dnormal! ==", start_line, end_line))
    end
  end,
})
