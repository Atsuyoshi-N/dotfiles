""""""""""""""""""""""""""""""""""""""
" マッピング
""""""""""""""""""""""""""""""""""""""
" leader キーとして<Space>を登録
let mapleader = "\<Space>"

" ESCをjkに
inoremap <silent> jk <ESC>

noremap <S-h> ^
noremap <S-l> $

" ノーマルモードで表示行単位での移動を可能に
nnoremap j gj
nnoremap k gk

"カーソル前の文字削除
inoremap <silent> <C-h> <C-g>u<C-h>
"カーソル後の文字削除
inoremap <silent> <C-d> <Del>
" 縦分割
map <Space>v :<C-u>vsplit<CR>
map <Space>w :<C-u>split<CR>

" === vimshell ===
nnoremap ,vv  :<C-u>VimShellPop<CR>

""""""""""""""""""""""""""""""""""""""
" かっこ補完
""""""""""""""""""""""""""""""""""""""
"{{{
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

function! DeleteParenthesesAdjoin()
    let pos = col(".") - 1  " カーソルの位置．1からカウント
    let str = getline(".")  " カーソル行の文字列
    let parentLList = ["(", "[", "{", "\'", "\""]
    let parentRList = [")", "]", "}", "\'", "\""]
    let cnt = 0

    let output = ""

    " カーソルが行末の場合
    if pos == strlen(str)
        return "\b"
    endif
    for c in parentLList
        " カーソルの左右が同種の括弧
        if str[pos-1] == c && str[pos] == parentRList[cnt]
            call cursor(line("."), pos + 2)
            let output = "\b"
            break
        endif
        let cnt += 1
    endfor
    return output."\b"
endfunction
" Ctrl-Hに割り当て
inoremap <silent> <C-h> <C-R>=DeleteParenthesesAdjoin()<CR>
"}}}

""""""""""""""""""""""""""""""""""""""
" vim-easy-align
""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)

""""""""""""""""""""""""""""""""""""""
" LSP keymap settings
""""""""""""""""""""""""""""""""""""""
nmap <silent> <Leader>d :LspDefinition<CR>
nmap <silent> <Leader>p :LspHover<CR>
nmap <silent> <Leader>r :LspReferences<CR>
nmap <silent> <Leader>i :LspImplementation<CR>
nmap <silent> <Leader>s :split \| :LspDefinition <CR>
nmap <silent> <Leader>v :vsplit \| :LspDefinition <CR>

