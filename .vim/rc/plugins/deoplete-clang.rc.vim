" libclang_path
" On GNU/Linx
" [sudo] find / -name libclang.so
" On macOS
" mdfind -name libclang.dylib
let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/7.0.1/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header  = '/usr/local/Cellar/llvm/7.0.1/Toolchains/LLVM7.0.1.xctoolchain/usr/lib/clang'
