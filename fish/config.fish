# Fix unthemed ls output: https://linuxhint.com/ls_colors_bash/
set -Ux LS_COLORS 'di=1a;35:fi=0;0'

# https://starship.rs
if exists starship
    starship init fish | source
end

# https://the.exa.website
if exists exa
    alias ls 'exa'
end
