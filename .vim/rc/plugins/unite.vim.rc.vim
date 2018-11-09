" start with insert mode
let g:unite_enable_start_insert = 1
" don't distinguish up case and down case
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

