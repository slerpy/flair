source /usr/share/cachyos-fish-config/cachyos-config.fish
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# CachyOS's config above defines its own aliases (ls, ll, la, etc.) which
# would otherwise clobber the ones in fish/conf.d/aliases.fish, since
# conf.d/ loads BEFORE config.fish. Re-source our conf.d files here so
# our versions win.
for f in ~/.dotfiles/fish/conf.d/*.fish
    source $f
end
