call plug#begin('~/.local/share/nvim/plugged')
" Visual customization
Plug 'arcticicestudio/nord-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" Languages
Plug 'https://gitlab.redox-os.org/redox-os/ion-vim.git'
Plug 'rust-lang/rust.vim'

" Functionality
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
call plug#end()

function! s:has_plugin(plugin)
	let lookup = 'g:plugs["' . a:plugin . '"]'
	return exists(lookup)
endfunction

let mapleader=","
set cursorline
set number
set hidden
set mouse=a
set nohls
set shortmess+=c
set signcolumn=yes
set background=dark
syntax on
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
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

nnoremap <left> <c-w>h
nnoremap <right> <c-w>l
nnoremap <down> <c-w>j
nnoremap <up> <c-w>k

inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")

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
    map <silent> <leader>f <Plug>(coc-fix-current)
    map <silent> <leader>o <Plug>(coc-format)
    map <silent> <leader>c <Plug>(coc-codeaction)
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
	inoremap <silent><expr> <c-,> coc#refresh()

	" Use <c-space> to trigger completion.
	inoremap <silent><expr> <c-space> coc#refresh()

	call coc#add_extension('coc-clangd', 'coc-git', 'coc-json', 'coc-python', 'coc-rust-analyzer', 'coc-sh', 'coc-texlab', 'coc-tabnine', 'coc-vimlsp')
endif

if s:has_plugin('lightline.vim')
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
endif

" Language settings

" LaTeX
autocmd FileType tex set linebreak

" Markdown
autocmd FileType markdown set linebreak
autocmd FileType markdown set tabstop=2
autocmd FileType markdown set softtabstop=2
autocmd FileType markdown set shiftwidth=2

autocmd FileType netrw setl bufhidden=wipe

augroup netrw_buf_hidden_fix
    autocmd!

    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif

augroup end

" colorscheme palenight
colorscheme nord
let g:palenight_terminal_italics=1
highlight Comment cterm=italic

set t_ZH=[3m
set t_ZR=[23m
