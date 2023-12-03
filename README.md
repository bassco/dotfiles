# dotfiles

Followed a [gist](https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f) to split out the installs and the gnu stow project for the config files.

## import config files workflow

You need [stow](https://www.gnu.org/software/stow/) installed. In my case `brew install stow` did the trick.

```console
# create an empty file to import
# e.g. ~/.aliases file
mkdir zsh
touch zsh/.aliases
stow --adopt zsh
```

This will symlink my `~/.aliases` file into the repo under the **_zsh_** folder.

You can _adopt_ multiple files or directories in on go. Or, can move content into the repo and then `stow` to update or create the symlinks.

## setting up a new machine

In the terminal issue the following commands:

```console
xcode-select --install
mkdir -p ~/dev/github/bassco
cd ~/dev/github/bassco
git clone https://github.com/bassco/dotfiles.git
cd dotfiles/installs
./brew-install.sh 
./asdf-install.sh 
./cargo-install.sh 
./macos-defaults.sh

# setup the dotfiles...
stow */
```
