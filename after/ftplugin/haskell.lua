-- ~/.config/nvim/after/ftplugin/haskell.lua

local ht = require("haskell-tools")
local wk = require("which-key")
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr }

-- Save if modified
local function save_if_modified()
  if vim.bo.modified then
    vim.cmd("update")
  end
end

-- Toggle REPL and move focus to it
local function toggle_repl_and_focus(pkg)
  save_if_modified()
  local wins_before = vim.api.nvim_list_wins()
  if pkg then
    ht.repl.toggle(pkg)
  else
    ht.repl.toggle()
  end
  vim.defer_fn(function()
    local wins_after = vim.api.nvim_list_wins()
    for _, win in ipairs(wins_after) do
      if not vim.tbl_contains(wins_before, win) then
        vim.api.nvim_set_current_win(win)
        vim.cmd("startinsert")
        vim.cmd("normal! G")
        break
      end
    end
  end, 50)
end

-- Key mappings
vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, opts)
vim.keymap.set("n", "<space>ch", ht.hoogle.hoogle_signature, opts)
vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)
vim.keymap.set("n", "<leader>rr", function()
  toggle_repl_and_focus()
end, opts)
vim.keymap.set("n", "<leader>rf", function()
  toggle_repl_and_focus(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)

-- which-key descriptions using new API
wk.add({
  { "<space>cl", vim.lsp.codelens.run, desc = "Run CodeLens", mode = "n" },
  { "<space>hs", ht.hoogle.hoogle_signature, desc = "Hoogle: Type Signature", mode = "n" },
  { "<space>ea", ht.lsp.buf_eval_all, desc = "Evaluate All Snippets", mode = "n" },
  {
    "<leader>rr",
    function()
      toggle_repl_and_focus()
    end,
    desc = "Toggle REPL (Package)",
    mode = "n",
  },
  {
    "<leader>rf",
    function()
      toggle_repl_and_focus(vim.api.nvim_buf_get_name(0))
    end,
    desc = "Toggle REPL (File)",
    mode = "n",
  },
  { "<leader>rq", ht.repl.quit, desc = "Quit REPL", mode = "n" },
  { "<leader>r", group = "REPL", mode = "n" },
}, { buffer = bufnr })
