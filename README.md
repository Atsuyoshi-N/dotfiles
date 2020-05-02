# dotfiles

# Getting Started

```
$ cd ~/
$ curl -fsSL https://raw.githubusercontent.com/Atsuyoshi-N/dotfiles/master/initialize_mac.sh | sh
```

# Setup

### neovim

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

- Linux, Mac

```
$ source [newenvname]/bin/activate
```

- Windows

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
