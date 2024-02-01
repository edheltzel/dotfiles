# Chekout recent branch with search an preview
#
function git-cbr
  set_color red
  if test (command -v git); and git rev-parse --is-inside-work-tree >/dev/null 2>&1
    git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1}" --pointer="" | xargs git checkout
  else
      echo -e "\e[31mError: Not a Git repository\e[0m"
  end
  set_color normal
end
