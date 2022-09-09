if test -d ~/.bin
    fish_add_path -aP ~/.bin
end

if test -d ~/.cargo
    fish_add_path -aP ~/.cargo/bin
end

if test -d ~/.deno
    set -x DENO_INSTALL ~/.deno
    fish_add_path -aP $DENO_INSTALL/bin
end

# Fix unthemed ls output: https://linuxhint.com/ls_colors_bash/
set -x LS_COLORS 'di=1;35:fi=0;0'

# VS Code alias for Silverblue 
if string match -q "*Silverblue*" (cat /etc/*-release | grep VARIANT= | head -n 1)
    alias code 'toolbox run --container dev code'
else if exists codium
    alias code codium
end

# https://containertoolbx.org/
if exists toolbox
    alias tb 'toolbox --container dev'
end

# https://flutter.dev/
if test -d ~/.tools/flutter
    fish_add_path -aP ~/.tools/flutter/bin
    set FLUTTER_ROOT ~/.tools/flutter
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
    alias ls exa
end

# https://www.terraform.io
if exists terraform
    alias tf terraform
end

# https://www.terraform.io/
if exists terraform
    alias tf terraform
end

# https://linux.die.net/man/1/espeak
if exists espeak
    alias say espeak
end

# Wayland clipboard
if exists wl-copy
    alias copy wl-copy
    alias paste wl-paste
end

# https://github.com/aristocratos/bpytop
if exists bpytop
    alias bashtop bpytop
end
