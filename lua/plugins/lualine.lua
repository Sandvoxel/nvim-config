return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
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
                        path = 1, -- 0 = name, 1 = relative, 2 = absolute
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
