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
au BufNewFile,BufRead Makefile setf make

" ファイル新規作成時のみテンプレートを読み込むようにする
" au BufNewFile *.cpp 0read ${HOME}/dotfiles/.vim/template/cpp.txt

au BufNewFile,BufRead *.es6    setfiletype javascript
au BufNewFile,BufRead *.vue    setfiletype html
au BufNewFile,BufRead *.ts     setlocal filetype=typescript
au BufNewFile,BufRead *.tsx    setfiletype typescript.tsx

" Completion Resultにdocstringを表示しない
au FileType python setlocal completeopt-=preview

" In makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
au FileType make set noexpandtab

" vim-go
" https://github.com/hnakamur/vim-go-tutorial-ja
" :GoBuildと:GoRunを簡略化
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>r <Plug>(go-run)

filetype plugin on

