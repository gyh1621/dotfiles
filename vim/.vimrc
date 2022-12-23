set encoding=utf-8
set nocp

set mouse=a

" 定义快捷键的前缀，即<Leader>
let mapleader="\<Space>"

nnoremap <Leader>vr :source $MYVIMRC<CR>:AirlineRefresh<CR>

" vim-plug
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

let g:plug_threads=16
let g:plug_shallow=1

" floaterm
nnoremap   <silent>   <leader>mm    :FloatermNew<CR>
tnoremap   <silent>   <leader>mm    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <leader>m,    :FloatermPrev<CR>
tnoremap   <silent>   <leader>m,    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <leader>m.    :FloatermNext<CR>
tnoremap   <silent>   <leader>m.    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <leader>mt   :FloatermToggle<CR>
tnoremap   <silent>   <leader>mt   <C-\><C-n>:FloatermToggle<CR>
nnoremap   <silent>   <leader>mk   :FloatermKill<CR>
tnoremap   <silent>   <leader>mk   <C-\><C-n>:FloatermKill<CR>
nnoremap   <silent>   <leader>mM   :FloatermNew --height=0.95 --width=0.95 --wintype=float<CR>
tnoremap   <silent>   <leader>mM   :FloatermNew --height=0.95 --width=0.95 --wintype=float<CR>

" bookmark
let g:bookmark_auto_save = 1
let g:bookmark_save_per_working_dir = 1

" fzf.vim
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" copilot
nmap <Leader>cp :vert bo Copilot panel<CR>
imap <C-c><C-c> <ESC>:vert bo Copilot panel<CR>

" coc
nmap <leader>fe <Plug>(coc-fix-current)
if filereadable(expand("~/.vimrc.coc"))
  source ~/.vimrc.coc
endif
" coc color
hi! CocHintFloat ctermbg=8 ctermfg=7
hi! CocErrorFloat ctermfg=7
hi! CocWarnFloat ctermbg=8 ctermfg=7
hi! CocWarningFloat ctermbg=8 ctermfg=7
hi! CocFloating ctermbg=8 ctermfg=11
hi! CocCodeLens ctermbg=8 ctermfg=7
hi! Pmenu ctermbg=8 ctermfg=7

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Expand Rust macro
nmap me <ESC>:CocCommand rust-analyzer.expandMacro<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

nmap <silent> gr <Plug>(coc-references)

function! s:GoToDefinition(splitType)
  if CocAction('jumpDefinition', a:splitType)
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gvd :call <SID>GoToDefinition('botright vsplit')<CR>
nmap <silent> ghd :call <SID>GoToDefinition('split')<CR>
nmap <silent> gtd :call <SID>GoToDefinition('tabe')<CR>

" coc end

" vim visual multi
" select all occurences in of that selection
nmap <C-w> <Plug>(VM-Select-All)
imap <C-w> <ESC><Plug>(VM-Select-All)
vmap <C-w> <ESC><Plug>(VM-Select-All)

" git gutter
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
command! Gqf GitGutterQuickFix | copen
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
" 让配置变更立即生效
"autocmd BufWritePost $MYVIMRC source $MYVIMRC
" 开启文件类型侦测
filetype on
" 根据侦测到的不同类型加载对应的插件
filetype plugin on
filetype plugin indent on
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
nnoremap <Leader>al <C-W>l
" 跳转至左方的窗口
nnoremap <Leader>ah <C-W>h
" 跳转至上方的子窗口
nnoremap <Leader>ak <C-W>k
" 跳转至下方的子窗口
nnoremap <Leader>aj <C-W>j
" 定义快捷键在结对符之间跳转
nmap <Leader>M %
" 调整水平分割窗口大小
nmap W= <ESC>:resize +3<CR>
nmap W- <ESC>:resize -3<CR>
" 调整垂直分割窗口大小
nmap W. <ESC>:vertical resize +3<CR>
nmap W, <ESC>:vertical resize -3<CR>

"" highlight current whole line
" highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
" set cursorline
"" highlight only current line number
set cursorline
set cursorlineopt=number
autocmd ColorScheme * highlight CursorLineNr cterm=bold term=bold gui=bold

" colorscheme
if strftime("%H") < 17 && strftime("%H") > 6
  set background=light
  silent! colorscheme xcodelight
  let g:airline_theme='light'
else
  set background=dark
  silent! colorscheme spaceduck
  let g:airline_theme='dark'
endif

if has('termguicolors')
    set termguicolors
endif

" Set contrast.
" This configuration option should be placed before `colorscheme everforest`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:everforest_background = 'medium'
" For better performance
let g:everforest_better_performance = 1

let g:deepspace_italics = 1

let g:one_allow_italics = 1

let g:edge_style = 'neon'
let g:edge_enable_italic = 1
let g:edge_better_performance = 1

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

    " set coc
    au FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyrightconfig.json']

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
    map <leader>T :TagbarToggle<CR>:AirlineRefresh<CR>
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
    let g:airline#extensions#coc#enabled = 1

    let g:airline_section_z = "%3p%% %l:%c"
    " show buffered tabs
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9
    nmap <leader>0 <Plug>AirlineSelectTab0
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
    let g:airline#extensions#tabline#tab_nr_type = 2
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

    let g:Lf_ShowDevIcons = 1

    " unbind <leader>b
    map <leader>b <Nop>

    highlight Lf_hl_match ctermbg=Yellow ctermfg=Black cterm=bold
" }

" delimitMate {
    let g:delimitMate_expand_cr = 2
" }

" ctrlsf {
    let g:ctrlsf_ackprg = 'rg'
    "let g:ctrlsf_default_view_mode = 'compact'
    let g:ctrlsf_default_root = 'project'
    nmap     <C-F>f <Plug>CtrlSFPrompt
    nmap     <C-F>w <Plug>CtrlSFCwordPath
    vmap     <C-F>v <Plug>CtrlSFVwordExec
    let g:ctrlsf_search_mode = 'async'
    let g:ctrlsf_auto_focus = {
    \ 'at': 'start',
    \ }
    let g:ctrlsf_mapping = {
    \ "next": "n",
    \ "prev": "N",
    \ }
    hi ctrlsfMatch guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=30 ctermbg=Yellow cterm=bold
" }

function! s:ShowMaps()
  let old_reg = getreg("a")          " save the current content of register a
  let old_reg_type = getregtype("a") " save the type of the register as well
try
  redir @a                           " redirect output to register a
  " Get the list of all key mappings silently, satisfy "Press ENTER to continue"
  silent map | call feedkeys("\<CR>")
  redir END                          " end output redirection
  vnew                               " new buffer in vertical window
  put a                              " put content of register
  " Sort on 4th character column which is the key(s)
  %!sort -k1.4,1.4
finally                              " Execute even if exception is raised
  call setreg("a", old_reg, old_reg_type) " restore register a
endtry
endfunction
com! ShowMaps call s:ShowMaps()      " Enable :ShowMaps to call the function

nnoremap \m :ShowMaps<CR>            " Map keys to call the function

" rust
let g:rustfmt_autosave = 0

" startify
let g:startify_session_before_save = [
        \ 'silent! :tabdo NERDTreeClose',
        \ 'silent! :bufdo NERDTreeClose'
        \ ]
