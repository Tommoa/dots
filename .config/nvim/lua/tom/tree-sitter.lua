local configs = require('nvim-treesitter.configs')
local uname = vim.loop.os_uname()

configs.setup {
    ensure_installed = "maintained",
    ignore_install = {},
    highlight = {
        -- Treesitter doesn't have 32-bit binaries
        enable = uname.machine ~= "i686",
        disable = {},
    },
}
