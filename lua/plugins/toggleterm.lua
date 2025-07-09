-- File: lua/plugins/toggleterm.lua

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
    on_open = function(_)
      local name = vim.fn.bufname("neo-tree")
      local winnr = vim.fn.bufwinnr(name)

      if winnr ~= -1 then
        vim.defer_fn(function()
          local cmd = string.format("Neotree toggle")
          vim.cmd(cmd)
          vim.cmd(cmd)
          vim.cmd("wincmd p")
        end, 100)
      end
    end,
    on_close = function() end,
  },
}
