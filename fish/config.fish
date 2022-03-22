if test -d ~/.bin
    fish_add_path -aP ~/.bin
end

if test -d ~/.cargo
    fish_add_path -aP ~/.cargo/bin
end


# Fix unthemed ls output: https://linuxhint.com/ls_colors_bash/
set -x LS_COLORS 'di=1;35:fi=0;0'

# Code alias for Silverblue setup
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

    # Fix missing locale variable in Silverblue. This removes the DNF warning. 
    set -x LC_ALL 'C.UTF-8'
end

# https://flutter.dev/
if test -d ~/.tools/flutter
    fish_add_path -aP ~/.tools/flutter/bin
    set FLUTTER_ROOT ~/Documents
end

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
if test -d ~/.tools/aws
    alias aws '~/.tools/aws/dist/aws'
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

# https://linux.die.net/man/1/espeak
if exists espeak
    alias say 'espeak'
end

# Wayland clipboard
if exists wl-copy
    alias copy 'wl-copy'
    alias paste 'wl-paste'
end

# https://github.com/aristocratos/bpytop
if exists bpytop
    alias bashtop 'bpytop'
end
