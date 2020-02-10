function changelog --description 'a git log pretty formant'
  set -l repo_url (repourl $argv)
  set -l output (outputfile $argv)
  command git log \
      --pretty=format:'{%n  "commit": "%H",%n  "author": "%aN <%aE>",%n  "date": "%ad",%n  "url": "$repo_url/%H",%n  "subject": "%s"%n },' \
      $argv | \
      perl -pe 'BEGIN{print "["}; END{print "]\n"}' | \
      perl -pe 's/},]/}]/' > $output
end

# Git
	alias git='hub'
