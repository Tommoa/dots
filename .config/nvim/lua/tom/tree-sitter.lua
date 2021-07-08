local configs = require('nvim-treesitter.configs')

configs.setup {
    ensure_installed = "maintained",
    ignore_install = {},
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = true,
    },
}
