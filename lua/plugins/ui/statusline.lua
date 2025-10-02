return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    -- LSP Progress Handler
    local lsp_messages = {}

    local function escape_status(text)
      return text and text:gsub("%%", "%%%%") or nil
    end

    vim.lsp.handlers["$/progress"] = function(_, result, ctx)
      local token = result.token
      local value = result.value
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then
        return
      end

      if value.kind == "begin" then
        lsp_messages[token] = {
          title = value.title or "",
          message = value.message or "",
          percentage = value.percentage,
          client = client.name,
        }
      elseif value.kind == "report" and lsp_messages[token] then
        lsp_messages[token].message = value.message or lsp_messages[token].message
        lsp_messages[token].percentage = value.percentage or lsp_messages[token].percentage
      elseif value.kind == "end" then
        lsp_messages[token] = nil
      end
    end

    local function lsp_status()
      local bufnr = vim.api.nvim_get_current_buf()
      local active = {}

      for _, msg in pairs(lsp_messages) do
        if msg.percentage then
          table.insert(active, escape_status(string.format("%s: %s (%d%%%%)", msg.client, msg.title, msg.percentage)))
        else
          table.insert(active, escape_status(string.format("%s: %s", msg.client, msg.title)))
        end
      end

      if #active > 0 then
        return table.concat(active, " | ")
      end

      local attached = {}
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.attached_buffers and client.attached_buffers[bufnr] then
          table.insert(attached, client.name)
        elseif vim.lsp.buf_is_attached(bufnr, client.id) then
          table.insert(attached, client.name)
        end
      end

      if #attached > 0 then
        return escape_status("LSP: " .. table.concat(attached, ", "))
      end

      return "LSP: Off"
    end

    require("lualine").setup({
      options = {
        theme = "gruvbox",
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = "●",
              readonly = "🔒",
              unnamed = "[No Name]",
            },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
          },
          lsp_status,
          "encoding",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "quickfix", "nvim-tree", "trouble", "lazy" },
    })
  end,
}
