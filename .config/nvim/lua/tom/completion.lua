local remap = vim.api.nvim_set_keymap

require'compe'.setup {
  enabled              = true;
  autocomplete         = true;
  debug                = false;
  min_length           = 1;
  preselect            = 'always';
  throttle_time        = 80;
  source_timeout       = 200;
  incomplete_delay     = 400;
  documentation        = true;

  source = {
    path = true;
    buffer = {
      enable = true,
      priority = 1,     -- last priority
    },
    luasnip = true;
    nvim_lsp = {
      enable = true,
      priority = 10001, -- takes precedence over file completion
    },
    nvim_lua = true;
    calc = true;
    omni = false;
    spell = false;
    tags = true;
    treesitter = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- How this works:
--  - If we can complete, complete
--  - If we can fill out a snipped, fill out a snippet
--  - Otherwise, put in a tab
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        -- vim.fn['coc#_select_confirm']()
        return vim.fn['compe#confirm']()
    -- elseif vim.fn['coc#expandableOrJumpable']() then
    elseif require'luasnip'.expand_or_jumpable() == 1 then
        -- return t "<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
        return require'luasnip'.expand_or_jump()
    else
        return t "<Tab>"
    end
end

-- I'd quite like control of my enter key back
-- I often find that with auto-complete on (and I always have it on), getting
-- to the end of a line without whitespace can be perilous, as the
-- auto-complete kicks in and decides to enter whatever it'd like when I hit
-- "enter" to go to a new line. This function fixes that
_G.do_enter_key = function()
    if vim.fn.pumvisible() == 1 then
        -- Make sure compe closes so that floating windows get cleaned up
        vim.fn['compe#close']()
    end
    return t '<C-g>u<CR>'
end

remap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true, silent = true, noremap = true})
remap('i', '<CR>',  "v:lua.do_enter_key()",  { expr = true, silent = true, noremap = true })
remap('i', '<C-e>', 'compe#close(\'<C-e>\')',   { silent = true, expr = true, noremap = true })
remap('i', '<C-f>', "compe#scroll({ 'delta': +4 })", { silent = true, expr = true, noremap = true })
remap('i', '<C-b>', "compe#scroll({ 'delta': -4 })", { silent = true, expr = true, noremap = true })
