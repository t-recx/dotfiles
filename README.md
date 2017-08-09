# My dotfiles

## Instalation

```sh
git clone https://github.com/t-recx/dotfiles.git
```

Submodules:

```sh
cd dotfiles
git submodule init
git submodule update
```

Install [autojump](https://github.com/wting/autojump)
```sh
git clone git://github.com/joelthelion/autojump.git
cd autojump
./install.py
cd ..
rm -rf autojump
```

Symlinks:

```sh
ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
ln -s ~/dotfiles/vim/gvimrc ~/.gvimrc
ln -s ~/dotfiles/irb/irbrc ~/.irbrc
mkdir -p ~/.config/awesome
ln -s ~/dotfiles/awesome ~/.config/awesome
ln -s ~/dotfiles/bash/bashrc ~/.bashrc
ln -s ~/dotfiles/bash/bash_aliases ~/.bash_aliases
ln -s ~/dotfiles/bash/scripts/mono-buildandrun ~/local/bin/mono-buildandrun
ln -s ~/dotfiles/awesome/scripts/lockscreen ~/local/bin/
mkdir -p ~/.config/sakura
ln -s ~/dotfiles/sakura/sakura.conf ~/.config/sakura/sakura.conf
ln -s ~/dotfiles/fluxbox/apps ~/.fluxbox/apps
ln -s ~/dotfiles/fluxbox/keys ~/.fluxbox/keys
ln -s ~/dotfiles/fluxbox/menu ~/.fluxbox/menu
ln -s ~/dotfiles/fluxbox/startup ~/.fluxbox/startup
ln -s ~/dotfiles/fluxbox/init ~/.fluxbox/init
ln -s ~/dotfiles/fluxbox/windowmenu ~/.fluxbox/windowmenu
```

## Random things:

### Adding another submodule:
```sh
git submodule add repository_url local_bundle_path
```
