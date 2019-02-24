# dotfiles

# Setup
### neovim
## Dein
### Deoplete
1. Check Python3 support
If `:echo has("python3")` returns 1, follow next steps

2. point Python3 PATH, and install pynvim
.vimrc
```
let g:python3_host_prog YOUR_PYTHON_PATH # Using Mac => YOUR_PYTHON_PATH == '/usr/local/bin/python3'
```
* Reference
  * [roxma/nvim-yarp](https://github.com/roxma/nvim-yarp#requirements)

3. add next script
dein.toml
```
call dein#add('Shougo/deoplete.nvim')
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif
let g:deoplete#enable_at_startup = 1
```
* Reference
  * [Shougo/deoplete.nvim](https://github.com/Shougo/deoplete.nvim)
