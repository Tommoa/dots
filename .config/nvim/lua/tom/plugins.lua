-- Package sources for my nvim config
--
-- Uses packer.nvim

-- Bootstrap packer.nvim
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
    -- Make packer manage itself
    use 'wbthomason/packer.nvim'

    -- Visual customization
    --  The actual theme will be selected by a variable elsewhere
    use {
        -- { 'arcticicestudio/nord-vim' },
        -- { 'chriskempson/base16-vim' },
        -- { 'drewtempelmeyer/palenight.vim' },
        {
            'joshdick/onedark.vim',
            config = function()
                vim.api.nvim_command('colorscheme onedark')
            end
        },
        {
            'glepnir/galaxyline.nvim',
            config = function()
                require('tom.statusline')
            end
        },
    }

    -- Completion engine
    use {
        -- { 'nvim-lua/completion-nvim' },
        {
            'hrsh7th/nvim-compe',
            config = function()
                require('tom.completion')
            end
        },
        { 'l3mon4d3/luasnip', requires = { 'hrsh7th/nvim-compe' } },
        -- {
        --     'neoclide/coc.nvim',
        --     run = function() fn['coc#util#install']() end,
        -- }
    }

    -- LSP
    use {
        { 'neovim/nvim-lspconfig' },
        {
            'nvim-lua/lsp-status.nvim',
            requires = { 'neovim/nvim-lspconfig' },
            config = function()
                require('tom.lsp')
            end
        },
    }

    -- Highlights
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/nvim-treesitter-refactor', 'nvim-treesitter/nvim-treesitter-textobjects'
        },
        config = function()
            require('tom.tree-sitter')
        end,
        run = ':TSUpdate'
    }

    -- Search
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        cmd = 'Telescope'
    }

    -- Git integration
    use {
        {
            'tpope/vim-fugitive',
            cmd = {
                'G', 'Git', 'Gstatus', 'Gblame',
                'Gpush', 'Gpull', 'Gedit',
            },
        },
        {
            'lewis6991/gitsigns.nvim',
            requires = {'nvim-lua/plenary.nvim'},
            config = function()
                require('gitsigns').setup()
            end
        },
    }

    -- Languages
    use {
        -- Rust
        {
            'simrat39/rust-tools.nvim',
            requires = {
                'neovim/nvim-lspconfig',
            },
            config = function()
                local lsp = require('tom.lsp')
                require('rust-tools').setup{
                    tools = {
                        hover_actions = {
                            auto_focus = true
                        },
                    },
                    server = {
                        on_attach = lsp.on_attach,
                        capabilities = lsp.capabilities,
                    },
                }
            end,
            ft = { 'rust' },
        },
        -- Nix
        { 'lnl7/vim-nix' },
        -- jsonc
        { 'kevinoid/vim-jsonc' },
        -- beancount
        { 'nathangrigg/vim-beancount' },
    }

    -- Org mode!
    use {'kristijanhusak/orgmode.nvim', opt = true}
end)
