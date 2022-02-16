if test -d ~/.bin
    fish_add_path ~/.bin
end

# Fix unthemed ls output: https://linuxhint.com/ls_colors_bash/
set -Ux LS_COLORS 'di=1a;35:fi=0;0'

# Code alias for Silverblue
if string match -q "*Silverblue*" (cat /etc/*-release | grep VARIANT= | head -n 1)
    alias code 'toolbox run code'
end

# https://containertoolbx.org/
if exists toolbox
    alias tb 'toolbox'

    # Expose specific scripts during toolbox session
    if set -q TOOLBOX_PATH
        fish_add_path -aP ~/.toolbox_bin
    end
end

# https://flutter.dev/
if test -d ~/.tools/flutter
    fish_add_path -aP ~/.tools/flutter/bin
    set FLUTTER_ROOT ~/Documents
end

# TODO: add aws cli
# if test -d ~/.tools/aws
    # fish_add_path -aP ~/.tools/aws/current/bin/aws
        # fish_add_path -aP ~/.tools/aws/current/bin/bin/aws
# end

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