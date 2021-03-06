" 検索後自動でquickfix windowを開く
autocmd QuickFixCmdPost *grep* cwindow
nnoremap <C-k> :cprevious<CR>
nnoremap <C-j> :cnext<CR>

""""""""""""""""""""""""""""""""""""""
" 表示設定
""""""""""""""""""""""""""""""""""""""

set ambiwidth=double    "文脈によって解釈が異なる全角文字の幅を、２に固定する
set backspace=indent,eol,start "バックスペースにてインデントを削除可能にする
set cursorline          " カーソル行をハイライト
set display=lastline    "長い文字列でも@でなくちゃんと表示する
set display=uhex        "バイナリファイルの非印字可能文字を16進数で表示
set expandtab           "tabを半角スペースで挿入する
set hidden              "ファイルの保存をしていなくても、別のファイルを開けるようにする
set lazyredraw          " コマンド実行中は再描画しない
set list                "空白文字の可視化
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% "可視化した空白文字の表示形式について
set matchtime=1         "showmatchによって対象括弧に飛ぶ時間を0.1秒に変更
set nrformats-=octal    "0で始まる数値を、8進数として扱わないようにする
set number              "行番号を表示する
set pumheight=10        "補完のポップアップの表示する件数を10
set scrolloff=5         "カーソルの上または下に表示する最小限の行数
set shiftwidth=2        "vimが自動で生成する（読み込み時など）tab幅をスペース2つ分にする
set showmatch           "括弧入力時の対応する括弧を表示
set smartindent         "オートインデント
set tabstop=2           "インデントをスペース2つ分に設定
set title               "編集中のファイル名を表示
set ttyfast             " 高速ターミナル接続を行う
set virtualedit=block   "文字のないところにカーソル移動できるようにする
set whichwrap=b,s,[,],<,>
set wildmenu            "コマンドライン補完を拡張モードにする
" set wrap                "ウィンドウの幅より長い行は折り返した、次の行に表示する
set shortmess+=I        "vimの初期画面を表示させない

" ペーストモードの挿入モードからノーマルモードに戻る時にペーストモードを解除する
autocmd InsertLeave * set nopaste
" convert tab to 2 spaces with saving
" autocmd BufWritePre * :%s/\t/  /ge
"}}}


"http://io-fia.blogspot.jp/2012/11/vimvimrc.html
""""""""""""""""""""""""""""""
" 入力補完を自動化
""""""""""""""""""""""""""""""
set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
  exec "imap <expr> " . k . " pumvisible() ? '" . k . "' : '" . k . "\<C-X>\<C-P>\<C-N>'"
endfor

" http://inari.hatenablog.com/entry/2014/05/05/231307
""""""""""""""""""""""""""""""
" 全角スペースの表示
""""""""""""""""""""""""""""""
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif


""""""""""""""""""""""""""""""""""""""
" 色
""""""""""""""""""""""""""""""""""""""
" 補完候補の色づけ for vim7
hi Pmenu ctermbg=255 ctermfg=0 guifg=#000000 guibg=#999999
hi PmenuSel ctermbg=blue ctermfg=black
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c
hi PmenuSbar ctermbg=0 ctermfg=9
hi PmenuSbar ctermbg=255 ctermfg=0 guifg=#000000 guibg=#FFFFFF

""""""""""""""""""""""""""""""""""""""
" 検索設定
""""""""""""""""""""""""""""""""""""""
set wrapscan    " 検索時に最後まで行ったら最初に戻る
set ignorecase  " 大文字/小文字の区別なく検索する
set smartcase   " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan    " 検索時に最後まで行ったら最初に戻る
set incsearch   " インクリメンタルサーチを行う
set hlsearch    " 検索結果をハイライト
" 検索結果を中央にくるようにする
nmap n nzz

""""""""""""""""""""""""""""""""""""""
" その他
""""""""""""""""""""""""""""""""""""""
set backupdir=$HOME/.vim/backup     " バックアップファイルのディレクトリを指定する
set nocompatible                  " vi互換をオフする
set directory=$HOME/.vim/backup     " スワップファイル用のディレクトリを指定する
set mouse=a                       " マウス操作をできるようにする
if has('nvim')
  set clipboard+=unnamedplus        " NeoVim用のクリップボード設定
else
  set clipboard=unnamed,autoselect  " ヤンクした文字は、システムのクリップボードに入れる
endif
set visualbell t_vb=              " エラービープ音を鳴らさない
set noerrorbells
set encoding=utf-8
set fileencodings=utf-8,cp932,iso-2022-jp,euc-jp,sjis,
set fileformats=unix,dos,mac

"クリップボードからノーマルモードの時に自動でペーストモードにしてインデントをしないようにする
if &term =~ "xterm"
    let &t_ti .= "\e[?2004h"
    let &t_te .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
    cnoremap <special> <Esc>[200~ <nop>
    cnoremap <special> <Esc>[201~ <nop>
endif

""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
" vim:set foldmethod=marker:

"crontab用にtmp/以下にバックアップを作成しない(tmp以下にバックアップを作成すると怒られる)
set backupskip=/tmp/*,/private/tmp/*

" neovim
set termguicolors

if has('nvim')
  let g:python_host_prog = expand('/usr/bin/python')
  let g:python3_host_prog = expand('/usr/bin/python3')
endif
