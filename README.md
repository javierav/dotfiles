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
$ brew tap homebrew/bundle
```

Install dependencies:

```
$ brew bundle
```


## License

Copyright (c) 2014-2023 Javier Aranda - Released under [MIT](LICENSE) license.
