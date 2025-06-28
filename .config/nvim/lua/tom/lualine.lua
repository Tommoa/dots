require('lualine').setup {
    options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '|' },
        disabled_filetypes = {
            'AvanteTodos',
            'AvanteSelectedFiles',
        },
    },
    extensions = {
        'avante',
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            {
                require('mcphub.extensions.lualine'),
                padding = { left = 1, right = 0 },
                icon = '(mcp)',
            },
            {
                'diagnostics',
                separator = '|',
                update_in_insert = true,
                icon='',
                symbols = { error = 'E ', warn = 'W ', info = 'I ', hint = 'H ' },
                padding = { left = 1, right = 1 },
            },
            {
                'filename',
                path = 1,
                shorting_target = 85,
            },
        },
        lualine_c = {
            {
                'branch',
                icon='',
                color = { fg = 'grey', }
            },
            {
                -- Get the root directory of the current git repository.
                function()
                    local git_dir = require('lualine.components.branch.git_branch').find_git_dir()
                    if not git_dir then
                        return ''
                    end

                    local git_root = git_dir:gsub('/.git/?$', '')
                    return git_root:match '^.+/(.+)$'
                end,
            },
            'diff',
            {
                'lsp_status',
                icon='(lsp)',
                padding = 0,
            },
        },
        lualine_x = {
            {
                "fileformat",
                icons_enabled = false,
            },
            "encoding",
            "filetype"
        },
    },
}
