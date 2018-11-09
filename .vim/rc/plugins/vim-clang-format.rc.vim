" ref: http://algo13.net/clang/clang-format-style-oputions.html
" ref: http://yasuharu519.hatenablog.com/entry/2015/12/13/210825
" C++14 support
let g:syntastic_cpp_compiler_options = '-std=c++14'
let g:clang_format#style_options = {
      \ "Language": "Cpp",
      \ "BasedOnStyle": "LLVM",
      \ "ContinuationIndentWidth": 2,
      \ "ConstructorInitializerIndentWidth": 2,
      \ }
"AlignConsecutiveAssignments": "false",
"AlignConsecutiveDeclarations": "false",
"AlignTrailingComments": "true",
"AllowShortBlocksOnASingleLine": "false",
"AllowShortCaseLabelsOnASingleLine": "false",
"AllowShortIfStatementsOnASingleLine": "true",
"BinPackParameters": "false",
"BinPackArguments": "false",
"BreakBeforeBinaryOperators": "None",
"DerivePointerAlignment": "false",
"IndentWidth": 2,
"IndentCaseLabels": "true",
"KeepEmptyLinesAtTheStartOfBlocks": "true",
"PointerAlignment": "Right",
"SpacesBeforeTrailingComments": 1,

