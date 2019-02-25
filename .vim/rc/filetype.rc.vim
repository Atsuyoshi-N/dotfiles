""""""""""""""""""""""""""""""""""""""
" Register filetype or syntax
""""""""""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.html   setf html
au BufNewFile,BufRead *.ejs    setf html
au BufNewFile,BufRead *.erb    setf eruby.html
au BufNewFile,BufRead *.haml   setf haml
au BufNewFile,BufRead *.slim   setf slim
au BufNewFile,BufRead *.scss   setf scss
au BufNewFile,BufRead *.js     setf javascript
au BufNewFile,BufRead *.jsx    setf javascript
au BufNewFile,BufRead *.json   setf json
au BufNewFile,BufRead *.coffee setf coffee
au BufNewFile,BufRead *.md     setf markdown
au BufNewFile,BufRead *.yml    setf yaml
au BufNewFile,BufRead *.php    setf php
au BufNewFile,BufRead *.sh     setf sh
au BufNewFile,BufRead *.tex    setf tex
au BufNewFile,BufRead *.vue    syntax sync fromstart

" ファイル新規作成時のみテンプレートを読み込むようにする
au BufNewFile *.cpp 0read ${HOME}/dotfiles/.vim/template/cpp.txt

autocmd BufNewFile,BufRead *.es6    setfiletype javascript
autocmd BufNewFile,BufRead *.vue    setfiletype html
" Completion Resultにdocstringを表示しない
autocmd FileType python setlocal completeopt-=preview

filetype plugin on

