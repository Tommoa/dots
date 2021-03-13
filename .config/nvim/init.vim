call plug#begin('~/.local/share/nvim/plugged')
" Visual customization
Plug 'arcticicestudio/nord-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'joshdick/onedark.vim'
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" Languages
Plug 'kevinoid/vim-jsonc'
Plug 'rust-lang/rust.vim'
Plug 'nathangrigg/vim-beancount'
Plug 'lnl7/vim-nix'

" Functionality
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'liuchengxu/vista.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

" Set the colourscheme
let s:scheme = 'onedark'
if (has("termguicolors"))
    set termguicolors
endif

"--- Helpful functions ---"
" Check if a plugin is loaded
function! s:has_plugin(plugin)
    let lookup = 'g:plugs["' . a:plugin . '"]'
    return exists(lookup)
endfunction
" Check if we can backspace whitespace
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"--- Settings ---"
let mapleader=","
set number
" Highlight the line that we're on
set cursorline
" Turn on mouse interaction
set mouse=a
" Don't highlight all matches in a search
set nohls
" Don't put completion menu messages into the messages area
set shortmess+=c
" Keep the gutter on the right open even if there's nothing there
set signcolumn=yes
" Turn on syntax highlighting
syntax on
" Set tab/shiftwidth to 4
set softtabstop=4
set shiftwidth=4
set tabstop=4
" Use spaces for indentation instead of tabs
set expandtab
" Make sure that CursorHold is triggered faster than every 4 seconds (4000)
set updatetime=300
" Use semantic indentation for all filetypes
filetype indent on
" Make sure that when we're spell checking, we use Australian English
set spelllang=en_au

"--- Keymaps ---"
" Colemak problems
noremap j e
noremap J E
noremap k n
noremap K N
noremap l u
noremap L U
noremap i l
noremap n gj
noremap e gk
noremap u i
noremap I L
noremap N J
noremap E K
noremap U I
" Normal-mode specific
nnoremap k nzzzv
nnoremap K Nzzzv
" Moving between panes
nnoremap <left> <c-w>h
nnoremap <right> <c-w>l
nnoremap <down> <c-w>j
nnoremap <up> <c-w>k
noremap <M-h> <c-w>h
noremap <M-n> <c-w>j
noremap <M-e> <c-w>k
noremap <M-i> <c-w>l
" Buffer-related keybinds
nnoremap <silent> zf :Sex<CR>
noremap <silent> <M-u> :bn!<CR>
noremap <silent> <M-l> :bp!<CR>
nnoremap <silent> zk :bd!<CR>
nnoremap gV `[v`]
" When using the nvim terminal, escape puts you back in normal mode
tnoremap <Esc> <c-\><c-n>

"--- Plugins ---"
if s:has_plugin('coc.nvim')
    " Utility functions
    function! CocCurrentFunction()
        return get(b:, 'coc_current_function', '')
    endfunction
    function! GitStatus() abort
        return get(b:, 'coc_git_status', '')
    endfunction
    " Autocommands
    " Auto-format the buffer every time a write is called
    autocmd BufWritePre * call CocAction('format')
    " Keymaps
    map <silent> <leader>h :call CocAction('doHover')<CR>
    map <silent> <leader>d <Plug>(coc-type-definition)
    map <silent> gc <Plug>(coc-git-commit)
    map <silent> gd <Plug>(coc-definition)
    map <silent> gi <Plug>(coc-implementation)
    map <silent> gr <Plug>(coc-references)
    map <silent> gs <Plug>(coc-git-chunkinfo)
    map <silent> <leader>r <Plug>(coc-rename)
    map <silent> <leader>f <Plug>(coc-fix-current)
    map <silent> <leader>o <Plug>(coc-format)
    map <silent> <leader>a <Plug>(coc-codeaction)
    map <silent> <leader>c :call coc#rpc#notify('runCommand', [])<CR>
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> [c <Plug>(coc-git-prevchunk)
    nmap <silent> ]c <Plug>(coc-git-nextchunk)
    " Ways to trigger completion
    inoremap <silent><expr> <c-,> coc#refresh()
    inoremap <silent><expr> <c-space> coc#refresh()
    " On tab...
    " If completion is up, select it
    " If you can expand or jump to the next snippet option, do it
    " Otherwise, insert tab
    inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ "\<TAB>"
    " Add a bunch of extensions
    call coc#add_extension(
                \ 'coc-clangd',
                \ 'coc-git',
                \ 'coc-jedi',
                \ 'coc-json',
                \ 'coc-markdownlint',
                \ 'coc-pyright',
                \ 'coc-python',
                \ 'coc-rust-analyzer',
                \ 'coc-sh',
                \ 'coc-snippets',
                \ 'coc-texlab',
                \ 'coc-tabnine',
                \ 'coc-vimlsp'
                \)
endif
if s:has_plugin('lightline.vim')
    " When the buffer changes, update the bufferline
    autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
    " Setting it up
    let g:lightline = {
                \ 'colorscheme': s:scheme,
                \ 'active': {
                \   'left': [
                \     [ 'mode', 'paste' ],
                \     [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified'],
                \     [ 'gitbranch', 'git' ]
                \   ],
                \   'right': [
                \     ['lineinfo'],
                \     ['percent'],
                \     ['fileformat', 'fileencoding', 'filetype'],
                \     ['spell'],
                \   ],
                \ },
                \ 'component_function': {
                \   'cocstatus': 'coc#status',
                \   'currentfunction': 'CocCurrentFunction',
                \   'git': 'GitStatus',
                \   'gitbranch': 'fugitive#statusline',
                \ },
                \ 'tabline': { 'left': [['buffers']] },
                \ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
                \ 'component_type': { 'buffers': 'tabsel' },
                \ }

    let g:lightline#bufferline#show_number  = 1
    let g:lightline#bufferline#shorten_path = 1
    let g:lightline#bufferline#unnamed      = '[No Name]'
endif
if s:has_plugin('vista.vim')
    if s:has_plugin('coc.nvim')
        let g:vista_default_executive = 'coc'
    else
        let g:vista_default_executive = 'nvim_lsp'
    endif
endif

"--- Language settings ---"
" LaTeX
autocmd FileType tex set linebreak
" Markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'rust', 'cpp']
autocmd FileType markdown set linebreak
autocmd FileType markdown set tabstop=2
autocmd FileType markdown set softtabstop=2
autocmd FileType markdown set shiftwidth=2
" YAML
autocmd FileType yaml set linebreak
autocmd FileType yaml set tabstop=2
autocmd FileType yaml set softtabstop=2
autocmd FileType yaml set shiftwidth=2

"--- NetRW settings ---"
autocmd FileType netrw setl bufhidden=wipe
augroup netrw_buf_hidden_fix
    autocmd!
    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif

augroup end

"--- Visuals ---"
if s:has_plugin('palenight.vim') && s:scheme == 'palenight'
    colorscheme palenight
endif
if s:has_plugin('nord-vim') && s:scheme == 'nord'
    colorscheme nord
endif
if s:has_plugin('onedark.vim') && s:scheme == 'onedark'
    colorscheme onedark
endif
if s:has_plugin('base16-vim')
    if s:scheme == 'Tomorrow_Night'
        colorscheme base16-tomorrow-night
    elseif s:scheme == 'darcula'
        colorscheme base16-dracula
    endif
endif
" Comments are italicized
highlight Comment cterm=italic gui=italic
" Make sure italics are displayed correctly
set t_ZH=[3m
set t_ZR=[23m

set shell=/bin/sh

" Load machine specific settings
let host = systemlist("uname -n")[0]
let filename = expand("~/.config/" . host . ".vim")
if filereadable(filename)
    exec "source " . filename
endif
if filereadable(expand("~/.config/sysinit.vim"))
    exec "source " . expand("~/.config/sysinit.vim")
endif
