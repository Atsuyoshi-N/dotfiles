# dotfiles
# Getting Started
```
$ cd ~/
$ curl -fsSL https://raw.githubusercontent.com/Atsuyoshi-N/dotfiles/master/initialize_mac.sh | sh
```

# Setup
### neovim
## Dein
Plugins that require additional configuration and their setting method are shown below.
### Deoplete
<details>
 <summary> Deoplete.nvim Settings</summary>

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
</details>

### vim-lsp
1. Add plugins to .toml file
dein.toml
```
[[plugins]]
repo = 'prabirshrestha/async.vim'

[[plugins]]
repo = 'prabirshrestha/vim-lsp'
```

2. Set up for each language
* [C, C++](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Clangd)
* [CSS/Less/Sass](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Css)
* [Docker](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Docker)
* [Go](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Go)
* [Javascript](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-JavaScript)
* [Python](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Python)
* [Ruby](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Ruby)
* [TypeScript](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-TypeScript)

## Python Env
For python environment, I use Python3.x, pip, and venv.

### Python3
```
$ brew install python3
```

### pip
If you use Python3.x(x more than4), pip has been a standard feature.
You can check whether pip is installed or not by next command.

```
$ pip -V
```

When pip is not installed, type next command
```
$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$ python get-pip.py
```

### venv
create new environment
```
$ cd [project dir]
$ python3 -m venv [newenvname]
```

#### Activate
* Linux, Mac
```
$ source [newenvname]/bin/activate
```
* Windows
```
$ .\[newenvname]\Scripts\activate
```

#### install packages
```
([newenvname])$ pip install [package name]
```

#### check installed packages
```
([newenvname]) $ pip freeze
```

#### Deactivate
```
([newenvname])$ deactivate
```
