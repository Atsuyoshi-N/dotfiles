function! s:source_setting_file(path, ...) abort
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand('~/.vim/rc/plugins/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute 'source' fnameescape(tempfile)
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction

"---------------------------------------------------------------------------
" Plugin:
"

call plug#begin('~/.vim/plugged')
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

Plug 'scrooloose/nerdtree'
call s:source_setting_file('nerdtree.rc.vim')

if has('nvim')
  " Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  " call s:source_setting_file('defx.rc.vim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  call s:source_setting_file('deoplete.rc.vim')
else
  " Plug 'Shougo/defx.nvim'
  " call s:source_setting_file('defx.rc.vim')
  Plug 'Shougo/deoplete.nvim'
  call s:source_setting_file('deoplete.rc.vim')
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/neosnippet.vim'
call s:source_setting_file('neosnippet.rc.vim')
Plug 'Shougo/neosnippet-snippets'
call s:source_setting_file('neosnippet-snippets.rc.vim')

Plug 'thinca/vim-quickrun'
call s:source_setting_file('vim-quickrun.rc.vim')

Plug 'vim-syntastic/syntastic'
call s:source_setting_file('vim-syntastic.rc.vim')

Plug 'w0ng/vim-hybrid'
call s:source_setting_file('vim-hybrid.rc.vim')

"
" Completion:
"

if has('win32') || has('win64')
  Plug 'tbodt/deoplete-tabnine', { 'do': 'powershell.exe .\install.ps1' }
else
  Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
endif

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
call s:source_setting_file('languageclient-neovim.rc.vim')

" (Optional) Multi-entry selection UI.
" Plug 'junegunn/fzf'

Plug 'itchyny/lightline.vim'
set laststatus=2

" Easy to mark up
Plug 'mattn/emmet-vim'
call s:source_setting_file('emmet-vim.rc.vim')

Plug 'Townk/vim-autoclose'
call s:source_setting_file('vim-autoclose.rc.vim')

" Toggle buffer
Plug 'Shougo/denite.nvim'
call s:source_setting_file('denite.rc.vim')

" Triming unnecessary whitespaces at the end of the line
Plug 'bronson/vim-trailing-whitespace'
call s:source_setting_file('vim-trailing-whitespace.rc.vim')

" auto set :paste mode
Plug 'ConradIrwin/vim-bracketed-paste'

" surround a text object with a specified block
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'
call s:source_setting_file('vim-operator-surround.rc.vim')

" jump if -> else -> end or ( -> ) etc...
Plug 'andymass/vim-matchup'
let g:loaded_matchit = 1

" Auto completion def -> end
Plug 'tpope/vim-endwise'

" かっこの対応をよしなに
Plug 'cohama/lexima.vim'

" Easy comment out
Plug 'scrooloose/nerdcommenter'
call s:source_setting_file('nerdcommenter.rc.vim')

" Easy align
Plug 'junegunn/vim-easy-align'
call s:source_setting_file('vim-easy-align.rc.vim')

" === Language Support ===
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ========== Golang ==========
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

call plug#end()
