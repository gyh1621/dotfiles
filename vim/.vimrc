set encoding=utf-8
set nocp

" 定义快捷键的前缀，即<Leader>
let mapleader="\<Space>"

" vim-plug
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" coc
if filereadable(expand("~/.vimrc.coc"))
  source ~/.vimrc.coc
endif
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
" 让配置变更立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC
" 开启文件类型侦测
filetype on
" 根据侦测到的不同类型加载对应的插件
filetype plugin on
" 开启实时搜索功能
set incsearch
" 搜索时大小写不敏感
set ignorecase
" 关闭兼容模式
set nocompatible
set backspace=indent,eol,start
" vim 自身命令行模式智能补全
set wildmenu

" 禁止光标闪烁
set gcr=a:block-blinkon0
" 禁止显示滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
" 禁止显示菜单和工具条
set guioptions-=m
set guioptions-=T

" 设置自动缩进
set autoindent
" 总是显示状态栏
set laststatus=2
" 显示光标当前位置
set ruler
" 开启行号显示
set number
" 高亮显示搜索结果
set hlsearch
nnoremap <Leader>\ :noh<return>
" 开启语法高亮功能
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on
" 自适应不同语言的智能缩进
filetype indent on
" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4

" set paste mode
set pastetoggle=<F11>

" 定义快捷键到行首和行尾
nmap LB 0
nmap LE $
" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪贴板内容粘贴至 vim
nmap <Leader>p "+p
" 定义快捷键关闭当前分割窗口
nmap <Leader>q :q<CR>
" 定义快捷键保存当前窗口内容
nmap <Leader>w :w<CR>
" 定义快捷键保存所有窗口内容并退出 vim
nmap <Leader>WQ :wa<CR>:q<CR>
" 不做任何保存，直接退出 vim
nmap <Leader>Q :qa!<CR>
" 依次遍历子窗口
"nnoremap NW <C-W><C-W>
" 跳转至右方的窗口
nnoremap <Leader>wl <C-W>l
" 跳转至左方的窗口
nnoremap <Leader>wh <C-W>h
" 跳转至上方的子窗口
nnoremap <Leader>wk <C-W>k
" 跳转至下方的子窗口
nnoremap <Leader>wj <C-W>j
" 定义快捷键在结对符之间跳转
nmap <Leader>M %
" 调整水平分割窗口大小
nmap W= <ESC>:resize +3<CR>
nmap W- <ESC>:resize -3<CR>
" 调整垂直分割窗口大小
nmap W. <ESC>:vertical resize +3<CR>
nmap W, <ESC>:vertical resize -3<CR>

" 配色方案
set background=dark
"colorscheme solarized
"colorscheme molokai
"colorscheme phd
" 设置状态栏主题风格
let g:Powerline_colorscheme='solarized256'

" vimtex
let g:tex_flavor = 'latex'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/MacOS/Skim'
let g:vimtex_compiler_enabled=1
let g:vimtex_quickfix_latexlog = {'default' : 0}
if !exists('g:ycm_semantic_triggers')
        let g:ycm_semantic_triggers = {}
    endif
    au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme

"tex.vim
let g:tex_conceal=""


" 标示不必要的空白字符
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t\+\|\t\+\zs \+/

" switch bwtween buffers
noremap <leader>bb :bn<cr>
noremap <leader>bp :bp<cr>
noremap <leader>bd :bd<cr>

" switch between tabs
noremap <leader>tt :tabn<cr>
noremap <leader>tp :tabp<cr>
noremap <leader>td :tabclose<cr>

" beancount{
    autocmd FileType beancount nnoremap . :AlignCommodity<CR>
    autocmd FileType beancount inoremap <Tab> <c-x><c-o>
" }

" python{

    let python_highlight_all=1

    au FileType python
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

    " 在新py文件开头添加执行路径，编码方式
    function! SetPyHeader()
        "call setline(1, "#!/usr/bin/python3")
        call setline(1, "# coding: utf-8")
        normal G
        normal o
    endfunc
    au BufNewFile *.py call SetPyHeader()

    " 编译运行
    nnoremap py<F5> <Esc>:w<CR>:!chmod a+x %<CR>:! ./%<CR>

" }

" c, c++{

    " 编译运行
    nnoremap <F5> <Esc>:w<CR>:!g++ -std=c++11 % -o /tmp/a.out && /tmp/a.out<CR>
    nnoremap <F7> <Esc>:w<CR>:!g++ -std=c++11 %<CR>

    au FileType cpp
    \ set smartindent

    au FileType c
    \ setlocal shiftwidth=2 |
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab autoindent smartindent cindent

    " 在新cpp文件开头添加iostream头文件以及main函数
    function! AddMainToNewCpp()
        call setline(1, "#include <iostream>")
        call append(1, "")
        call append(2, "")
        call append(3, "int main(){")
        call append(4, "")
        call append(5, "}")
        normal G
        normal o
    endfunc
    au BufNewFile *.cpp call AddMainToNewCpp()

"}

" java{

    " 编译运行
    nnoremap <F10> <Esc>:w<CR>:!javac % && java %:r <CR>

" }

" html{

    au BufNewFile, BufRead *.html
    \ set tabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab autoindent |

    " emmet快速注释
    autocmd filetype *html* imap <c-_> <c-y>/
    autocmd filetype *html* map <c-_> <c-y>/

" }

let g:vitality_shell_cursor = 1

" tags {
    nnoremap <leader>pT :!ctags %<ENTER><ENTER>
" }

" nerdtree {
    map <leader>n :NERDTreeToggle<CR>
" }

" tagbar {
    map <leader>t :TagbarToggle<CR>:AirlineRefresh<CR>
    let g:tagbar_ctags_bin = 'ctags'
" }

" gutentags {
    set statusline+=%{gutentags#statusline()}
    " https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
    let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
    command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')
    let g:gutentags_generate_on_new = 1
    let g:gutentags_generate_on_missing = 1
    let g:gutentags_generate_on_write = 1
    let g:gutentags_generate_on_empty_buffer = 0
    let g:gutentags_ctags_extra_args = [
          \ '--tag-relative=yes',
          \ '--fields=+ailmnS',
          \ ]
" }

" ale {
    " show errors or warnings in statusline
    let g:airline#extensions#ale#enabled = 1
    let g:ale_linter = {
    \   'c': ['clangtidy', 'gcc'],
    \}
    "   'python': ['flake8', 'pylint']
    "\}
    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'c': ['clang-format'],
    \   'python': ['black'],
    \   'json': ['jq']
    \}
    let g:ale_fix_on_save = 1

    "let g:ale_python_flake8_options = "--max-line-length=120"

    nmap <silent> <leader>aa :lopen<CR>
    nmap <silent> <leader>ad :lclose<CR>
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }

" airline {
    " show buffered tabs
    let g:airline#extensions#tabline#enabled = 1
    " enable highlght cache
    let g:airline_highlighting_cache = 1
    " hide buffer line when there is only one tab/buffer
    fu! AirlineBufLineToggle()
        let b_num = len(getbufinfo({'buflisted':1}))
        if b_num == 1 | set go+=e | doautocmd user AirlineToggledOff |endif
        if b_num > 1 | set go-=e | doautocmd user AirlineToggledOn |endif
    endfu

    au BufNewFile * :call AirlineBufLineToggle()
    au BufWinEnter * :call AirlineBufLineToggle()
    au BufEnter * :call AirlineBufLineToggle()

" }

" LeaderF {
    " don't show the help in normal mode
    let g:Lf_HideHelp = 1
    let g:Lf_UseCache = 0
    let g:Lf_UseVersionControlTool = 0
    let g:Lf_IgnoreCurrentBufferName = 1
    " popup mode
    let g:Lf_WindowPosition = 'popup'
    let g:Lf_PreviewInPopup = 1
    let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2" }
    let g:Lf_PreviewResult = {'Function': 1, 'BufTag': 1, 'Tag': 1, 'Rg': 1}
    let g:Lf_PreviewCode = 0

    let g:Lf_WorkingDirectoryMode = 'a'

    let g:Lf_ShortcutF = "<leader>ff"
    noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
    noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
    noremap <leader>ft :<C-U><C-R>=printf("Leaderf tag %s", "")<CR><CR>
    noremap <leader>fr :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
    noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
    noremap <leader>fs :<C-U><C-R>=printf("Leaderf rg %s", "")<CR><CR>

    let g:Lf_ShowDevIcons = 0

    " unbind <leader>b
    map <leader>b <Nop>
" }

" delimitMate {
    let g:delimitMate_expand_cr = 2
" }

" ctrlsf {
    let g:ctrlsf_ackprg = 'ag'
    let g:ctrlsf_default_view_mode = 'compact'
    let g:ctrlsf_default_root = 'project'
    nmap     <C-F>f <Plug>CtrlSFPrompt
    nmap     <C-F>w <Plug>CtrlSFCwordPath
    vmap     <C-F>v <Plug>CtrlSFVwordExec
    let g:ctrlsf_search_mode = 'async'
    let g:ctrlsf_auto_focus = {
    \ 'at': 'start',
    \ }
" }
