function sizeof --wraps='du -h -s' --description 'get size of files or directories'
    du -h -s $argv
end