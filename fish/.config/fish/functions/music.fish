function music -d "Control Music. Use -h or --help for a more detailed description."
  if [ (count $argv) -gt 0 ]
    set -l opt $argv[1]
    switch $opt
      case launch play pause stop rewind resume quit
      case mute
        set opt "set mute to true"
      case unmute
        set opt "set mute to false"
      case next previous
        set opt "$opt track"
      case vol volume
        set opt "set sound volume to $argv[2]"
      case "" -h --help
        echo "Usage: music <option>"
        echo "option:"
        echo \t"launch, play, pause, stop, rewind, resume, quit"
        echo \t"mute, unmute    Control volume set"
        echo \t"next, previous  Play next or previous track"
        echo \t"vol             Set the volume, takes an argument from 0 to 100"
        echo \t"help            Show this message and exit"
        return 0
      case '*'
        echo "Unknown option $opt. Use -h or --help for a more detailed description."
        return 1
    end
    osascript -e "tell application \"Music\" to $opt"
  else
    echo "No arguments given. Use -h or --help for a more detailed description."
  end
end
