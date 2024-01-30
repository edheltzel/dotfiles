complete -c artisan -s h -l help           -d 'Display this help message' -f
complete -c artisan -s q -l quiet          -d 'Do not output any message' -f
complete -c artisan -s V -l version        -d 'Display this application version' -f
complete -c artisan -s n -l no-interaction -d 'Do not ask any interactive question' -f
complete -c artisan -s v -l verbose        -d 'Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug' -f
complete -c artisan -l ansi                -d 'Force ANSI output' -f
complete -c artisan -l no-ansi             -d 'Disable ANSI output' -f
complete -c artisan -l env                 -d 'The environment the command should run under' -f

function __artisan_entries
    php artisan --no-ansi | sed "1,/Available commands/d" | string match -i -r '\s+.+?\s+' | string trim
end

complete -f -c artisan -a '(__artisan_entries)'
