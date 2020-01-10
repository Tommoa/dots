call plug#begin('~/.local/share/nvim/plugged')
Plug 'https://gitlab.redox-os.org/redox-os/ion-vim.git'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'LnL7/vim-nix'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'rust-lang/rust.vim'
Plug 'sjl/gundo.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()

function! s:has_plugin(plugin)
	let lookup = 'g:plugs["' . a:plugin . '"]'
	return exists(lookup)
endfunction

let mapleader=","
set relativenumber
set number
set showtabline=2
set hidden
set mouse=a
set nohls
set shortmess+=c
set signcolumn=yes
set background=dark
syntax on
set tabstop=4
set shiftwidth=4
set wildoptions=pum
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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

tnoremap <Esc> <c-\><c-n>

if s:has_plugin('gundo.nvim')
	map <silent> <leader>l :GundoToggle<CR>
endif

if s:has_plugin('coc.nvim')
	function! CocCurrentFunction()
		return get(b:, 'coc_current_function', '')
	endfunction

	map <silent> <leader>h :call CocAction('doHover')<CR>
	map <silent> <leader>d <Plug>(coc-type-definition)
	map <silent> gd <Plug>(coc-definition)
	map <silent> gi <Plug>(coc-implementation)
	map <silent> gr <Plug>(coc-references)
	map <silent> <leader>r <Plug>(coc-rename)
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" Use tab for trigger completion with characters ahead and navigate.
	" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
	"
	" Commented out because I want my TAB key back for now
	"inoremap <silent><expr> <TAB>
	"	  \ pumvisible() ? "\<C-n>" :
	"	  \ <SID>check_back_space() ? "\<TAB>" :
	"	  \ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

	" Use <c-space> to trigger completion.
	inoremap <silent><expr> <c-space> coc#refresh()

	call coc#add_extension('coc-git', 'coc-json', 'coc-python', 'coc-rls', 'coc-vimlsp', 'coc-texlab', 'coc-tabnine', 'coc-pyright', 'coc-sh')
endif

if s:has_plugin('lightline.vim')
	autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

	let g:lightline = {
		  \ 'colorscheme': 'palenight',
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
endif

autocmd FileType netrw setl bufhidden=wipe

augroup netrw_buf_hidden_fix
    autocmd!

    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif

augroup end

if s:has_plugin('goyo.vim')
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
endif

colorscheme palenight
let g:palenight_terminal_italics=1

set t_ZH=[3m
set t_ZR=[23m
