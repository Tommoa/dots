-- Check to see whether the Obsidian dir exists. If it does not, then we should
-- not start the obsidian plugin.
local obsidian_dir = vim.fn.expand "~/Documents/Personal/"
if vim.fn.filereadable(obsidian_dir) == 0 then
    return
end

require('obsidian').setup {
    -- Only one obsidian workspace :)
    workspaces = {
        {
            name="personal",
            path="~/Documents/Personal",
        },
    },
    -- Setup completion.
    completion = {
        nvim_cmp = true,
        min_chars = 2,
    },
    -- Setup the picker.
    picker = {
        name = "telescope.nvim",
    },
    -- Put new notes in the "Encounters" subdir.
    new_notes_location = "Encounters",
    -- Set attachments to the correct folder.
    attachments = {
        img_folder = "Extras/Attachments",
    },
    -- Make sure that daily notes are in the right spot.
    daily_notes = {
        folder = "Calendar/Daily",
        date_format = "%Y-%m-%d",
        -- template = nil
    },
}
