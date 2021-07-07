-- Set the mapleader. This should be done first to make sure that it works in the rest of my keybindings
vim.g.mapleader = ","

require'tom.config'   -- Set some general options
require'tom.plugins'  -- Load plugins. This will also load my completion and LSP configs
require'tom.keybinds' -- Load some keybinds

-- Kick off machine-specific config files
local host = vim.fn.systemlist "uname -n"
local config_dir = vim.fn.expand "~/.config/"
local filenames = {
    config_dir .. host[1] .. '.vim',
    config_dir .. host[1] .. '.lua',
    config_dir .. 'sysinit.vim',
    config_dir .. 'sysinit.lua',
}
for _, v in ipairs(filenames) do
    if vim.fn.filereadable(v) == 1 then
        vim.api.nvim_command('source ' .. v)
    end
end
