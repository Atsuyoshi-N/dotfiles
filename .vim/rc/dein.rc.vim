"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/atsuyoshi/.cache/dein/repos/github.com/Shougo/dein.vim
set runtimepath+=/Users/atsuyoshi/.cache/dein/repos/github.com/Shougo/vimproc.vim/autoload/vimproc.vim

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Let dein manage dein
  " Required:
  call dein#add(s:dein_repo_dir)

  " プラグインリストを収めたTOMLファイル
  let g:rc_dir    = expand('~/dotfiles/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'


  " if ((has('nvim')  || has('timers')) && has('python3')) && system('pip3 show neovim') !=# ''
  "   call dein#add('Shougo/deoplete.nvim')
  "   if !has('nvim')
  "     call dein#add('roxma/nvim-yarp')
  "     call dein#add('roxma/vim-hug-neovim-rpc')
  "   endif
  " endif
  "TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 0})

  " Add or remove your plugins here like this:
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

