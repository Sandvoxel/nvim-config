return {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
        require('window-picker').setup()

        vim.keymap.set("n", "<leader>w", function()
            local picked = require("window-picker").pick_window()
            if picked then
                vim.api.nvim_set_current_win(picked)
            end
        end, { desc = "Pick and jump to window" })
    end,
}
