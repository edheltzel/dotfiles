# fish completion for voicemode
function __fish_voicemode_complete
    set -l response (env _VOICEMODE_COMPLETE=fish_complete COMP_WORDS=(commandline -cp) COMP_CWORD=(commandline -t) voicemode 2>/dev/null)

    for completion in $response
        echo $completion
    end
end

complete -c voicemode -f -a '(__fish_voicemode_complete)'
