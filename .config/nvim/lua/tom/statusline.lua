local gl = require 'galaxyline'
local condition = require 'galaxyline.condition'

local gls = gl.section
gl.short_line_list = { 'packer', 'NvimTree', 'Outline', 'LspTrouble' }

-- These colours match onedark.vim
local colors = {
    bg = '#282c34',
    fg = '#abb2bf',
    section_bg = '#3E4452',
    blue = '#61afef',
    green = '#98c379',
    purple = '#c678dd',
    orange = '#e5c07b',
    red = '#e06c75',
    yellow = '#e5c07b',
    darkgrey = '#2c323d',
    middlegrey = '#8791A5',
}


local mode_color = function()
    local mode_colors = {
        [110] = colors.green,
        [105] = colors.blue,
        [99] = colors.green,
        [116] = colors.blue,
        [118] = colors.purple,
        [22] = colors.purple,
        [86] = colors.purple,
        [82] = colors.red,
        [115] = colors.red,
        [83] = colors.red,
    }

    local color = mode_colors[vim.fn.mode():byte()]
    if color ~= nil then
        return color
    else
        return colors.purple
    end
end

local function file_readonly()
    if vim.bo.filetype == 'help' then
        return ''
    end
    if vim.bo.readonly == true then
        return ' | RO '
    end
    return ''
end

local function get_current_file_name()
    local file = vim.fn.expand '%:t'
    if vim.fn.empty(file) == 1 then
        return ' '
    end
    if string.len(file_readonly()) ~= 0 then
        return file .. file_readonly()
    end
    if vim.bo.modifiable then
        if vim.bo.modified then
            return file .. ' + '
        end
    end
    return file .. ' '
end

local function get_basename(file)
    return file:match '^.+/(.+)$'
end

local GetGitRoot = function()
    local git_dir = require('galaxyline.provider_vcs').get_git_dir()
    if not git_dir then
        return ''
    end

    local git_root = git_dir:gsub('/.git/?$', '')
    return get_basename(git_root)
end

local LspStatus = function()
    if #vim.lsp.get_clients() > 0 then
        local status = vim.trim(require('lsp-status').status())
        if status:len() > 0 then
            status = status .. ' | '
        end
        return status
    end
    return ''
end

-- Left side
gls.left[1] = {
    ViMode = {
        provider = function()
            local aliases = {
                [110] = 'NORMAL',
                [105] = 'INSERT',
                [99] = 'COMMAND',
                [116] = 'TERMINAL',
                [118] = 'VISUAL',
                [22] = 'V-BLOCK',
                [86] = 'V-LINE',
                [82] = 'REPLACE',
                [115] = 'SELECT',
                [83] = 'S-LINE',
            }
            vim.api.nvim_command('hi GalaxyViMode guibg=' .. mode_color())
            local alias = aliases[vim.fn.mode():byte()]
            local mode
            if alias ~= nil then
                mode = alias
            else
                mode = vim.fn.mode():byte()
            end
            return '  ' .. mode .. ' '
        end,
        highlight = { colors.bg, colors.bg },
        separator = ' ',
        separator_highlight = { colors.fg, colors.section_bg },
    },
}
gls.left[3] = {
    LspStatus = {
        provider = { LspStatus },
        condition = condition.check_active_lsp,
        highlight = { colors.fg, colors.section_bg },
    },
}
gls.left[4] = {
    FilePath = {
        provider = function()
            local fp = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
            local tbl = vim.split(fp, '/', true)
            local len = #tbl

            if len > 2 and not len == 3 and not tbl[0] == '~' then
                return '…/' .. table.concat(tbl, '/', len - 1) .. '/' -- shorten filepath to last 2 folders
                -- alternative: only 1 containing folder using vim builtin function
                -- return '…/' .. vim.fn.fnamemodify(vim.fn.expand '%', ':p:h:t') .. '/'
            else
                return fp .. '/'
            end
        end,
        highlight = { colors.middlegrey, colors.section_bg },
    },
}
gls.left[5] = {
    FileName = {
        provider = get_current_file_name,
        highlight = { colors.fg, colors.section_bg },
        separator = ' ',
        separator_highlight = { colors.middlegrey, colors.bg },
    },
}
gls.left[6] = {
    GitBranch = {
        provider = function () return vim.fn.FugitiveHead(10) end,
        condition = condition.check_git_workspace,
        highlight = { colors.middlegrey, colors.bg },
        separator = ' ',
        separator_highlight = { colors.middlegrey, colors.bg },
    },
}
gls.left[7] = {
    GitRoot = {
        provider = GetGitRoot,
        highlight = { colors.fg, colors.bg },
        separator = ' ',
        separator_highlight = { colors.middlegrey, colors.bg },
    },
}
gls.left[8] = {
    DiffAdd = {
        provider = 'DiffAdd',
        icon = '+',
        highlight = { colors.green, colors.bg },
        separator = ' ',
        separator_highlight = { colors.section_bg, colors.bg },
    },
}
gls.left[9] = {
    DiffModified = {
        provider = 'DiffModified',
        icon = '~',
        highlight = { colors.orange, colors.bg },
    },
}
gls.left[10] = {
    DiffRemove = {
        provider = 'DiffRemove',
        icon = '-',
        highlight = { colors.red, colors.bg },
    },
}

-- Right side
gls.right[1] = {}
gls.right[2] = {
    FileInfo = {
        provider = function()
            local encode = vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
            return vim.bo.fileformat .. ' | ' .. encode .. ' | ' .. vim.bo.filetype .. ' '
        end,
        highlight = { colors.fg, colors.bg },
    },
}
gls.right[3] = {
    PerCent = {
        provider = {
            'LinePercent',
        },
        highlight = {colors.fg, colors.section_bg},
        separator = ' ',
        separator_highlight = { colors.fg, colors.section_bg },
    },
}
gls.right[5] = {
    LineColumn = {
        provider = function()
            local line = vim.fn.line('.')
            local column = vim.fn.col('.')
            vim.api.nvim_command('hi GalaxyLineColumn guibg=' .. mode_color() .. ' guifg=' .. colors.bg)
            return string.format('%2d:%-2d ', line, column)
        end,
        highlight = 'GalaxyLineColumn',
        separator = ' ',
        separator_highlight = 'GalaxyLineColumn',
    }
}

-- Short status line
gls.short_line_left[1] = {
    FileName = {
        provider = get_current_file_name,
        highlight = { colors.fg, colors.section_bg },
    },
}

gls.short_line_right[1] = {
    PerCent = {
        provider = 'LinePercent',
        highlight = { colors.bg, colors.fg },
        separator = '',
        separator_highlight = { colors.section_bg, colors.bg },
    },
}

gls.short_line_right[2] = {
    ShortLineColumn = {
        provider = function()
            local line = vim.fn.line('.')
            local column = vim.fn.col('.')
            return string.format('%2d:%-2d ', line, column)
        end,
        highlight = { colors.bg, colors.fg },
        separator = ' ',
        separator_highlight = { colors.bg, colors.fg },
    }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
