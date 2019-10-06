let g:extra_whitespace_ignored_filetypes = ['defx', 'denite']
" Execute :FixWhitespace command before writing file to buffer
autocmd BufWritePre * :FixWhitespace

