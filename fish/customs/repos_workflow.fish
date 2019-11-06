function repo
    set -l repo_path (repodir $argv)
    echo "$repo_path"
    cd "$repo_path"
end

function repodir
    set repo_base ~/Projects
    set repo_path (find "$repo_base" -mindepth 2 -maxdepth 2 -type d -name "*$argv*" | head -n 1)
    if not test "$argv"; or not test "$repo_path"
        set repo_path "$repo_base"
    end
    echo "$repo_path"
end

function forrepos --description 'Evaluates $argv for all repo folders'
    for d in (find ~/Projects -mindepth 2 -maxdepth 2 ! -path . -type d)
        pushd $d
        set repo (basename $d)
        echo $repo
        eval (abbrex $argv)
        popd > /dev/null
    end
end

# Often used shortcuts/aliases
function projects; cd ~/Projects; end
function work; cd ~/Projects/work/epluno; end
function dots; cd ~/Projects/personal/dot_files; end
function cuts; ~/Projects/personal/dot_files; and eval $EDITOR .; end
