function prc --description 'jj-aware gh pr create into dev'
    set -l bm (jj log --no-graph -r 'latest(bookmarks() & ::@)' -T 'bookmarks' | string trim |
  string split ' ')[1]
    if test -z "$bm"
        echo "no bookmark on @ or its ancestors"
        return 1
    end
    gh pr create --base dev --head $bm -a "@me" --fill-first $argv
end
