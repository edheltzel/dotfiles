function mkbak --description "Create a .bak copy of a file"
  cp -- "$argv[1]" "$argv[1].bak"
end
