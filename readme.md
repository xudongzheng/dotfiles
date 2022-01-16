I am [Xudong Zheng](https://www.xudongz.com/) and this repository contains my
dotfiles. This isn't meant to be used directly but rather can provide
inspiration for things to include in your own dotfiles.

You will find this helpful if you use some of the same software that I use. This
includes:

- Go for general programming
- Vim for text editing
- Git for version control
- tmux for terminal multiplexing
- Colemak keyboard layout

# How to Use

I run the following command to setup my dotfiles on a new system.

```
git clone git://github.com/xudongzheng/dotfiles.git dot && bash dot/setup.sh && exit
```

The `setup.sh` script will untrack the master branch from remote. Rather than
doing `git pull`, the `pull.sh` script is used to pull the changes from GitHub.
That script checks that the latest remote commit is signed using my private PGP
key before merging.
