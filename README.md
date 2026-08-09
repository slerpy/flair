# Flair v3.0

adding bounce to systems step. boingboingboing.

fish, bash, linux, mac (theoretically?)

## Basic idea
we keep all of our dotfiles in one place, the .dotfiles dir.

we simlink to all of them.

when you need to edit, you know where they're at, in the .dotfiles dir

then just git add .dotfiles or whatever

### Install

copy .dotfiles to your ~ home dir
- or ya know, jsut git clone this repo into ~/.dotfiles

enter .dotfiles dir

make install.sh executable (... chmod +x install.sh)
./install.sh

this should simlink the relevant files to the files in the .dotfiles dir
- if the file already exists, it will make a copy of that file in .dotfiles/backups before it overwrites it with a simlink

you may or may not need to make world_time executable.. if so, chmod +x etc..




### Global gitignore

look, dont blindly use this gitignore... srsly dont.  added just about everything could think of for gitignore... but you really should double check before trusting it.


## Optional installs

a couple of things require extra stuff... both should be available in jsut about every distros repos.

- dust, but only for the one piece... namely for nicer tree of disk usage, it will fall back to du -sh if you dont want to install dust.
- nmap, for local network scan.
- gifify, needs ffmpeg and gifsicle


## NOTE

currently, if backups are created, these  go into a backup dir inside the .dotfiles folder.  there is a .gitignore that excludes these backups in order to help prevent accidental leakages to git.  if you prefer those backups to go into git, edit the .gitignore file.

<3
