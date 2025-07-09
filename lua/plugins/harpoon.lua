return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():append()
        end, { desc = "Add file to Harpoon" })
        vim.keymap.set("n", "<leader>hh", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon Menu" })
        vim.keymap.set("n", "<leader>h1", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon to file 1" })
        vim.keymap.set("n", "<leader>h2", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon to file 2" })
        vim.keymap.set("n", "<leader>h3", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon to file 3" })
        vim.keymap.set("n", "<leader>h4", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon to file 4" })
    end,
}
