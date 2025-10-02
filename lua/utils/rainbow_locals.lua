local M = {}

local ns = vim.api.nvim_create_namespace("rainbow_locals")
local defaults = {
  "#b8bb26", -- green
  "#83a598", -- blue
  "#fabd2f", -- yellow
  "#fe8019", -- orange
  "#d3869b", -- purple
  "#8ec07c", -- aqua
  "#fb4934", -- red
}

local highlight_groups = {}
local augroup

local function define_highlights(palette)
  highlight_groups = {}
  for idx, color in ipairs(palette) do
    local name = string.format("RainbowLocalIdentifier%d", idx)
    highlight_groups[idx] = name
    vim.api.nvim_set_hl(0, name, { fg = color, italic = false })
  end
end

local function highlight_node(bufnr, node, group)
  if not node or not group then
    return
  end

  local sr, sc, er, ec = node:range()
  vim.api.nvim_buf_add_highlight(bufnr, ns, group, sr, sc, ec)
end

local allowed_kinds = {
  ["definition.var"] = true,
  ["definition.parameter"] = true,
  ["definition.local"] = true,
}

local function collect_definition_nodes(definition)
  local locals = require("nvim-treesitter.locals")
  local nodes = {}

  for _, entry in ipairs(locals.get_local_nodes(definition)) do
    if entry.node then
      local kind = entry.kind or ""
      if allowed_kinds[kind] or kind:find("definition.var", 1, true) or kind:find("definition.parameter", 1, true) then
        table.insert(nodes, entry.node)
      end
    end
  end

  return nodes
end

local function highlight_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  if vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "" then
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    return
  end

  local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok_parsers then
    return
  end

  local parser = parsers.get_parser(bufnr)
  if not parser then
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    return
  end

  local locals = require("nvim-treesitter.locals")
  local ts = vim.treesitter

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local tree = parser:parse()[1]
  if not tree then
    return
  end

  local root = tree:root()
  if not root then
    return
  end

  local color_for_definition = {}
  local next_index = 1

  local function pick_group(def_node)
    if not def_node then
      return nil
    end
    local key = tostring(def_node)
    if not color_for_definition[key] then
      local group = highlight_groups[next_index]
      if not group then
        return nil
      end
      color_for_definition[key] = group
      next_index = next_index + 1
      if next_index > #highlight_groups then
        next_index = 1
      end
    end
    return color_for_definition[key]
  end

  for match in locals.iter_locals(bufnr, root) do
    local data = match["local"]
    if data.definition then
      for _, node in ipairs(collect_definition_nodes(data.definition)) do
        local text = ts.get_node_text(node, bufnr)
        if text and text ~= "" and text ~= "_" then
          local group = pick_group(node)
          if group then
            highlight_node(bufnr, node, group)
          end
        end
      end
    end
    if data.reference and data.reference.node then
      local ref_node = data.reference.node
      local def_node = select(1, locals.find_definition(ref_node, bufnr))
      local group = pick_group(def_node)
      if group then
        highlight_node(bufnr, ref_node, group)
      end
    end
  end
end

function M.setup(opts)
  opts = opts or {}
  local palette = opts.palette or defaults
  define_highlights(palette)

  if augroup then
    pcall(vim.api.nvim_del_augroup_by_id, augroup)
  end
  augroup = vim.api.nvim_create_augroup("RainbowLocals", { clear = true })

  local function schedule_highlight(bufnr)
    vim.schedule(function()
      highlight_buffer(bufnr)
    end)
  end

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI", "InsertLeave" }, {
    group = augroup,
    callback = function(args)
      schedule_highlight(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      schedule_highlight(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    callback = function()
      define_highlights(palette)
    end,
  })
end

return M
