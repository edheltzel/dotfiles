function imgcon --description "recursive Imagemagick converter"
  set -q fileType[1] and
  set -q fileType[2] and
  for image in **
    echo $image | grep -qE '.*$fileType[1].*'; and \
      convert -verbose $image (echo $image | sed "s/$fileType[1]/$fileType[2]/g")
  end
end
