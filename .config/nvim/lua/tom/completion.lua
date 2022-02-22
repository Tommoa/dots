-- local remap = vim.api.nvim_set_keymap
local cmp = require('cmp')

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- How this works:
--  - If we can complete, complete
--  - If we can fill out a snipped, fill out a snippet
--  - Otherwise, put in a tab
_G.tab_complete = function(args)
    if cmp.visible() then
        -- vim.fn['coc#_select_confirm']()
        return cmp.confirm()
    -- elseif vim.fn['coc#expandableOrJumpable']() then
    elseif require'luasnip'.expand_or_jumpable() then
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
_G.do_enter_key = function(args)
    if cmp.visible() then
        -- Make sure compe closes so that floating windows get cleaned up
        cmp.close()
    end
    return t '<C-g>u<CR>'
end

-- remap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true, silent = true, noremap = true})
-- remap('i', '<CR>',  "v:lua.do_enter_key()",  { expr = true, silent = true, noremap = true })
-- remap('i', '<C-e>', 'compe#close(\'<C-e>\')',   { silent = true, expr = true, noremap = true })
-- remap('i', '<C-f>', "compe#scroll({ 'delta': +4 })", { silent = true, expr = true, noremap = true })
-- remap('i', '<C-b>', "compe#scroll({ 'delta': -4 })", { silent = true, expr = true, noremap = true })

cmp.setup {
  experimental = {
    ghost_text = true;
  };

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  };

  completion = {
    keyword_length = 1;
    completeopt = "menu,menuone,noinsert";
    -- autocomplete = true;
  };

  mapping = {
    ['<Tab>'] = cmp.mapping(_G.tab_complete, { "i", "c" });
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' });
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' });
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    });
  };

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "cmp_tabnine" },
    { name = "path" },
    { name = "buffer" },
    { name = "calc" },
  });
}

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local tabnine = require('cmp_tabnine.config')
tabnine:setup({
  max_lines = 1000;
  max_num_results = 20;
  sort = true;
  run_on_every_keystroke = true;
  snippet_placeholder = '..';
  ignored_file_types = {
    -- default is not to ignore
    -- uncomment to ignore in lua:
    -- lua = true
  };
})
