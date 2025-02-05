" Plugins
call plug#begin()
    Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
    " Status & tab bars
    Plug 'itchyny/lightline.vim'
    " Automaticly create closing bracket
    Plug 'windwp/nvim-autopairs'
    " Plugin for comfortable navigating
    Plug 'preservim/nerdtree'
    " Plugin for surround text in something faster
    Plug 'kylechui/nvim-surround'
    " Plugin for snippets
    Plug 'dcampos/nvim-snippy'
    " Plugin for git integration
    Plug 'tpope/vim-fugitive'
    " LSP
    Plug 'neovim/nvim-lspconfig'
call plug#end()

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Set variables
set number
set relativenumber
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set termguicolors

" Use system clipboard
set clipboard+=unnamedplus

" My leader key is space
let mapleader = " "
" Close NERDTree when I open something in it
let g:NERDTreeQuitOnOpen = 1
" C is cool
let g:c_syntax_for_h = 1
let g:lightline = {
      \ 'colorscheme': 'catppuccin',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

autocmd TermOpen * setlocal nonumber norelativenumber


" Set mappings
" Toggle files tree
nmap <silent> <Leader>y :NERDTreeToggle<CR>
" Navigate in splits
nmap <silent> <Leader>k :wincmd k<CR>
nmap <silent> <Leader>j :wincmd j<CR>
nmap <silent> <Leader>h :wincmd h<CR>
nmap <silent> <Leader>l :wincmd l<CR>
" Switch tabs
nmap <silent> H :tabp<CR>
nmap <silent> L :tabn<CR>
" Edit size of split
nmap <silent> <c-k> :resize +5<CR>
nmap <silent> <c-j> :resize -5<CR>
nmap <silent> <c-h> :vertical resize -5<CR>
nmap <silent> <c-l> :vertical resize +5<CR>
" Hide search highlighting
nmap <silent> <Leader>n :nohlsearch<CR>
" Saving time to not write ":Git "
nmap <Leader>g :Git 
nmap <silent> <Leader>q :enew<bar>bd #<CR>
nmap <silent> <Leader>v :vsplit<CR>
nmap <silent> <Leader>s :split<CR>

" Terminal
nnoremap <silent> <Leader>t :terminal<CR>i
tnoremap <silent> <C-c><C-c> <C-\><C-n>

" For snippets
imap <expr> <Tab> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-advance)' : '<Tab>'
imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>'
smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
xmap <Tab> <Plug>(snippy-cut-text)

" Create blank like below or above
nmap <silent> zj o<Esc>k
nmap <silent> zk O<Esc>j

" Sessions
nmap <Leader>z :mksession!<CR>
nmap <Leader>x :source Session.vim<CR>
nmap <Leader>e :mksession! <bar> :wqa<CR>


" Setupping
colorscheme catppuccin-frappe
lua require('nvim-surround').setup()
lua require('nvim-autopairs').setup()
lua require('lspconfig').pyright.setup({})
lua require('lspconfig').clangd.setup({})
" lua require('toggleterm').setup()

