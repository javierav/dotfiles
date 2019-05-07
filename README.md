# dotfiles

My personal dotfiles config.


## Requirements

* [Git](https://git-scm.com)
* [Homebrew](https://brew.sh)


## Installation

Clone this repository in your home directory:

```
$ git clone https://github.com/javierav/dotfiles.git .dotfiles
```

Install dotfiles:

```
$ cd .dotfiles && ./install.sh
```

### Submodules

We use git submodules for include other projects inside this.

```
$ cd .dotfiles && git submodule update --init
```

### Brew dependencies

Install Homebrew Bundle package:

```
$ brew tap Homebrew/bundle
```

Install dependencies:

```
$ brew bundle
```

### Atom Editor packages

Install Atom from [atom.io](https://atom.io) and then

```
$ cd .dotfiles && ./atom/load_atom_packages.sh
```


## License

Copyright (c) 2019 Javier Aranda - Released under [MIT](LICENSE) license
