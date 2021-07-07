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
    vsnip = true;
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
    elseif vim.fn['vsnip#available'](1) == 1 then
        -- return t "<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
        return t "<Plug>(vsnip-expand-or-jump)"
    else
        return t "<Tab>"
    end
end

remap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true, silent = true})
remap('i', '<CR>',  'compe#confirm(\'<CR>\')',  { silent = true, expr = true })
remap('i', '<C-e>', 'compe#close(\'<C-e>\')',   { silent = true, expr = true })
remap('i', '<C-f>', "compe#scroll({ 'delta': +4 })", { silent = true, expr = true })
remap('i', '<C-b>', "compe#scroll({ 'delta': -4 })", { silent = true, expr = true })
