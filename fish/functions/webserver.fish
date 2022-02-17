function webserver --wraps 'python3 -m http.server' --description 'cats a manpage'
    python3 -m http.server $argv
end