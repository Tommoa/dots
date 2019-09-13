call plug#begin('~/.local/share/nvim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'https://gitlab.redox-os.org/redox-os/ion-vim.git'
Plug 'iamcco/coc-vimlsp', {'do': 'yarn install --frozen-lockfile'}
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'LnL7/vim-nix'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree', { 'on' : 'NERDTreeToggle' }
Plug 'sjl/gundo.vim'
call plug#end()

let mapleader=","
set relativenumber
set number
set showtabline=2
set hidden
set mouse=a
set nohls
set shortmess+=c
set signcolumn=yes
syntax on
set tabstop=4
set shiftwidth=4
filetype indent on

nnoremap i l
nnoremap n gj
nnoremap e gk
nnoremap I L
nnoremap N J
nnoremap E K
nnoremap u i
nnoremap U I

nnoremap j e
nnoremap J E
nnoremap k nzzzv
nnoremap K Nzzzv
nnoremap l u
nnoremap L U

onoremap i l
onoremap n j
onoremap e k
onoremap u i
onoremap I L
onoremap N J
onoremap E K
onoremap U I

onoremap j e
onoremap J E
onoremap k n
onoremap K N
onoremap l u
onoremap L U

vnoremap i l
vnoremap n j
vnoremap e k
vnoremap u i
vnoremap I L
vnoremap N J
vnoremap E K
vnoremap U I

vnoremap j e
vnoremap J E
vnoremap k n
vnoremap K N
vnoremap l u
vnoremap L U

noremap <c-w> <c-w>k
noremap <c-a> <c-w>h
noremap <c-r> <c-w>j
noremap <c-s> <c-w>l
noremap <c-q> <c-w>-
noremap <c-f> <c-w>+
noremap <M-h> <c-w>h
noremap <M-n> <c-w>j
noremap <M-e> <c-w>k
noremap <M-i> <c-w>l

nnoremap <silent> zs :w!<CR>
nnoremap <silent> zf :Sex<CR>
noremap <silent> <M-u> :bn!<CR>
noremap <silent> <M-l> :bp!<CR>
nnoremap <silent> zk :bd!<CR>
nnoremap gV `[v`]

let g:autofmt_autosave = 1

map <silent> H :call CocAction('doHover')<CR>
map <silent> <leader>d <Plug>(coc-type-definition)
map <silent> gd <Plug>(coc-definition)
map <silent> gi <Plug>(coc-implementation)
map <silent> gr <Plug>(coc-references)
map <silent> <leader>r Plug(coc-rename)
map <silent> <leader>l :GundoToggle<CR>
map <silent> <leader>n :NERDTreeToggle<CR>

let g:NERDTreeMapOpenSplit = "u"
let g:NERDTreeMapOpenExpl = "y"
let g:NERDTreeMapUpdir = "l"
let g:NERDTreeMapUpdirKeepOpen = "L"

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

tnoremap <Esc> <c-\><c-n>

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
	  \ 'tabline': { 'left': [['buffers']] },
	  \ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
	  \ 'component_type': { 'buffers': 'tabsel' },
      \ }

let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'

autocmd FileType netrw setl bufhidden=wipe

augroup netrw_buf_hidden_fix
    autocmd!

    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif

augroup end

function! s:goyo_enter()
	if executable('tmux') && strlen($TMUX)
		silent !tmux set status off
		silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
	endif
endfunction

function! s:goyo_leave()
	if executable('tmux') && strlen($TMUX)
		silent !tmux set status on
		silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
	endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

colorscheme nord 

set t_ZH=[3m
set t_ZR=[23m
