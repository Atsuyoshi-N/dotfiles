set background=dark
" colorscheme設定はsource後に行う必要があるのでVimEnterで行う
" ただしColorschemeイベントの発生が抑制されないようnestedをつける
au MyAutoCmd VimEnter * nested colorscheme hybrid

