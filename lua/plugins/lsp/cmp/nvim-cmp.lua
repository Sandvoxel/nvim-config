return {
  "hrsh7th/nvim-cmp",
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    local kind_priority = {
      [cmp.lsp.CompletionItemKind.Field] = 110,
      [cmp.lsp.CompletionItemKind.Property] = 100,
      [cmp.lsp.CompletionItemKind.Variable] = 90,
      [cmp.lsp.CompletionItemKind.Method] = 80,
      [cmp.lsp.CompletionItemKind.Function] = 70,
      [cmp.lsp.CompletionItemKind.Class] = 60,
      [cmp.lsp.CompletionItemKind.Interface] = 50,
      [cmp.lsp.CompletionItemKind.Module] = 40,
      [cmp.lsp.CompletionItemKind.Enum] = 30,
    }

    local function preceding_char()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      if col == 0 then
        return ""
      end
      local line = vim.api.nvim_get_current_line()
      return line:sub(col, col)
    end

    local function kind_comparator(entry1, entry2)
      local kind1 = kind_priority[entry1:get_kind()] or 0
      local kind2 = kind_priority[entry2:get_kind()] or 0
      if kind1 == kind2 then
        return nil
      end
      return kind1 > kind2
    end

    local function dot_context_comparator(entry1, entry2)
      if preceding_char() ~= "." then
        return nil
      end
      local preferred = {
        [cmp.lsp.CompletionItemKind.Field] = true,
        [cmp.lsp.CompletionItemKind.Property] = true,
      }
      local entry1_is_field = preferred[entry1:get_kind()] or false
      local entry2_is_field = preferred[entry2:get_kind()] or false
      if entry1_is_field == entry2_is_field then
        return nil
      end
      return entry1_is_field
    end

    cmp.setup({
      completion = {
        keyword_length = 2,
        completeopt = "menu,menuone,noinsert,noselect",
      },
      confirmation = {
        default_behavior = cmp.ConfirmBehavior.Insert,
      },
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
          select = false,
          behavior = cmp.ConfirmBehavior.Insert,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      matching = {
        disallow_fuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = true,
      },
      sources = {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 250 },
      },
      sorting = {
        priority_weight = 3,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          dot_context_comparator,
          kind_comparator,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, vim_item)
          local menus = {
            nvim_lsp = "λ",
            luasnip = "⋗",
            buffer = "Ω",
          }
          vim_item.menu = menus[entry.source.name] or entry.source.name
          return vim_item
        end,
      },
      experimental = {
        ghost_text = true,
      },
    })
  end,
}
