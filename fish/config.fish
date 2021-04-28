# SSH-Agent: https://wiki.archlinux.org/index.php/SSH_keys#Keychain
export SHELL=fish
eval (keychain --quiet --eval --agents ssh $argv)
export SHELL=dash

# https://starship.rs
if exists starship
    starship init fish | source
end

# https://the.exa.website
if exists exa
    alias ls 'exa'
end

# https://the.exa.website
if exists exa
    alias ls 'exa'
end

# https://github.com/aristocratos/bpytop
if exists bpytop
    alias bashtop 'bpytop'
end