return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.setup({
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    -- Add a custom rule for Rust-style generics: <...>
    npairs.add_rule(
      Rule("<", ">", { "-html", "-javascriptreact", "-typescriptreact" }) -- exclude HTML/JSX
        :with_pair(cond.before_regex("%a+:?:?$", 3)) -- e.g. after Vec, Option, std::
        :with_move(function(opts)
          return opts.char == ">"
        end)
        :with_cr(cond.none()) -- don't auto-pair on carriage return
    )

    -- Integrate with nvim-cmp for proper bracket handling
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
