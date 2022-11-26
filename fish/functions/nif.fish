if exists nix
    function nif --description 'Aliases for common Nix commands'
        if test (count $argv) -ge 1
            switch $argv[1]
                # Common actions
                case search
                    nix-env -qaP $argv[2..-1]
                case preview
                    nix-shell -p $argv[2..-1]
                ## No args
                case clean
                    nix-collect-garbage -d
                case repl
                    nix repl
                case packages
                    xdg-open 'https://search.nixos.org'
                # Nix sub-commands
                case shell
                    nix-shell $argv[2..-1]
                case env
                    nix-env $argv[2..-1]
                case '*'
                    echo 'Subcommand does not exist'
            end
        else
            echo 'No subcommand passed';
        end
    end
end


