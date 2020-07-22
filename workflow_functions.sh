#!/bin/bash

throw(){ echo $@ >&2 ; exit 1; }
          
set_image_name(){ 
  image_name=`echo $1 | tr A-Z a-z | sed s/_\.\*//g`; 
  image_name=${image_name#*/};
  tag_name=`echo $1 | tr A-Z a-z | sed s/\.\*_//g`; 
  img_desc="${LOGIN_NAME:-coshapp}/${image_name:?no imagename}:${tag_name:?no tagname}-${coshapp_ver:?no ver}" 
}
          
build_image(){ 
  for coshapp_ver in ${coshapp_ver:-10.4-slim}; do 
    for j in $@; do
      export coshapp_ver;
      set_image_name $j ;
      docker build --build-arg=coshapp_ver=$coshapp_ver -t ${img_desc:?img not specified} -f $j .;
      docker push $img_desc
    done &
  done
  wait
}
