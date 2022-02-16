# Fix unthemed ls output: https://linuxhint.com/ls_colors_bash/
set -Ux LS_COLORS 'di=1a;35:fi=0;0'

# https://containertoolbx.org/
if exists toolbox
    alias tb 'toolbox'

    # Expose scripts meant for use in toolbox
    if set -q TOOLBOX_PATH
        fish_add_path ~/.toolbox_bin
    end
end

# https://starship.rs
if exists starship
    starship init fish | source
end

# https://the.exa.website
if exists exa
    alias ls 'exa'
end

# https://www.terraform.io/
if exists terraform
    alias tf 'terraform'
end