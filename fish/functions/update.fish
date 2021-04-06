function read_confirm
  while true
    read -l -P 'Do you want to continue? [y/N] ' confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end

function update
  echo 'This will update everything';
  if read_confirm
    command topgrade $argv;
  end

end
