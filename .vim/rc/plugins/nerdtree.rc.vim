nnoremap <silent><C-e> :NERDTreeToggle<CR>
" show bookmark from the beginning
let g:NERDTreeShowBookmarks=1
let NERDTreeIgnore = ['\.ppm', '\.pgm', '\.jpg', '\.jpeg', '\.png', '\.pdf']
" ファイル指定で開かれた場合はNERDTreeは表示しない
if !argc()
  autocmd vimenter * NERDTree|normal gg3j
endif

