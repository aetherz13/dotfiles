" Loading vim addons
set runtimepath^=/usr/share/vim/vimfiles

" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'pgdouyon/vim-evanesco'

Plug 'kana/vim-operator-user'
Plug 'tyru/operator-camelize.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'dag/vim-fish'
Plug 'cespare/vim-toml'
Plug 'fidian/hexmode'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'kergoth/vim-bitbake'
Plug 'lilydjwg/fcitx.vim', { 'branch': 'fcitx4' }
Plug 'mhinz/vim-grepper'
Plug 'ntpeters/vim-better-whitespace'
Plug 'preservim/nerdcommenter'
Plug 'preservim/tagbar'
Plug 'rhysd/conflict-marker.vim'
Plug 'rhysd/vim-clang-format'
Plug 'romainl/vim-qf'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'vim-scripts/pacmanlog.vim'
call plug#end()

" vim-airline
set noshowmode
let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#enabled=0
let g:airline#extensions#tagbar#flags='f'
let g:airline#extensions#hunks#non_zero_only=1
let g:airline#extensions#tabline#enabled = 1

" tagbar
let g:tagbar_autofocus=1

" vim-gitgutter
set signcolumn=yes
set updatetime=100
highlight! link SignColumn LineNr

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" vim-grepper
let g:grepper               = {}
let g:grepper.tools         = ['rg', 'git']
let g:grepper.quickfix      = 1

" quick-scope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" hexmode
let g:hexmode_patterns = '*.bin,*.o,*.img,*.dat'
let g:hexmode_xxd_options = '-g 1'

" vim-better-whitespace
let g:better_whitespace_filetypes_blacklist=['qf']

" vim-lsp
imap <c-space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
let g:lsp_diagnostics_enabled = 0
set completeopt-=preview

" fzf.vim
function! FZFOperator(type) abort
  let reg_save = @@
  let sel_save = &selection
  let &selection = 'inclusive'

  if a:type =~? 'v'
    silent execute "normal! gvy"
  elseif a:type == 'line'
    silent execute "normal! '[V']y"
  else
    silent execute "normal! `[v`]y"
  endif

  let &selection = sel_save
  let query = shellescape(substitute(@@, '\n\+$', '', ''))
  let @@ = reg_save

  call fzf#vim#grep(
    \ "rg --column --line-number --no-heading --color=always --smart-case -- ".query,
    \ 1, fzf#vim#with_preview({'options': ['--info=inline']}))
  return 0
endfunction

" Highlighting
highlight ColorColumn ctermfg=white ctermbg=237 guibg=#3a3a3a
highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=211
highlight clear SpellCap
highlight SpellCap cterm=underline ctermfg=117

set background=dark
set clipboard^=unnamedplus
set colorcolumn=+1
set ignorecase
set smartcase
set wildignorecase
set list
set listchars=tab:\|-,nbsp:+
set undofile
set nrformats+=alpha
set number
set textwidth=80
set visualbell t_vb=
set hidden
set complete+=kspell
set inccommand=split
set shortmess+=Ss
syntax sync minlines=500

" Key bindings
let mapleader=","
noremap <leader>t :TagbarToggle<CR>
nmap <leader>c <Plug>(operator-camelize-toggle)
nnoremap <leader>g :Grepper -tool rg<cr>
nnoremap <leader>G :Grepper -tool git<cr>
let g:grepper.next_tool = '<leader>g'
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
inoremap <leader><leader> <Esc>
nnoremap <C-k> :bprevious<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <silent> <leader>f :set opfunc=FZFOperator<cr>g@
xnoremap <silent> <leader>f :<c-u>call FZFOperator(visualmode())<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" Map 'key' to toggle 'opt'
function MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

MapToggle <leader>s spell
MapToggle <leader>w wrap
MapToggle <leader>i ignorecase

" FileType-specific settings
autocmd FileType gitcommit  setlocal tw=72 spell
autocmd FileType svn        setlocal tw=72 spell
autocmd FileType html       setlocal tw=100
autocmd FileType javascript setlocal tw=100
autocmd FileType markdown   setlocal tw=100
autocmd FileType xml        setlocal tw=100

" Set filetype for custom file extensions
au BufNewFile,BufRead pacman.log setlocal ft=pacmanlog
au BufNewFile,BufRead Kbuild setlocal ft=make

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif

" Terminal settings
" https://github.com/neovim/neovim/issues/2601
if exists(':terminal')
  let g:terminal_scrollback_buffer_size = 100000

  tnoremap <Esc><Esc> <C-\><C-n>
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
  tnoremap <A-l> <C-\><C-n><C-w>l
  tnoremap <A-c> <C-\><C-n><C-w>c
  nnoremap <A-h> <C-w>h
  nnoremap <A-j> <C-w>j
  nnoremap <A-k> <C-w>k
  nnoremap <A-l> <C-w>l
  nnoremap <A-c> <C-w>c
  tnoremap <A-d>t   <C-\><C-n>:vsp \| term bash -l<CR>
  tnoremap <A-d>    <C-\><C-n>:vsp<CR>
  tnoremap <A-s-d>t <C-\><C-n>:sp \| term bash -l<CR>
  tnoremap <A-s-d>  <C-\><C-n>:sp<CR>
  nnoremap <A-d>t   <ESC>:vsp \| term bash -l<CR>
  nnoremap <A-d>    <ESC>:vsp<CR>
  nnoremap <A-s-d>t <ESC>:sp \| term bash -l<CR>
  nnoremap <A-s-d>  <ESC>:sp<CR>

  tnoremap ;; <C-\><C-n>
  tnoremap <C-k> <C-\><C-n>:bprevious<CR>
  tnoremap <C-j> <C-\><C-n>:bnext<CR>

  au BufEnter term://* startinsert
endif
