if [ "$#" -ne 2 ];
then
  echo -e "Usage: Either \n\t$0 xml-file xpath-file\nor\n\t$0 xml-file expr"
else
  if [[ -f $2 ]];
  then
    i=$(<$2)
  else
    i=$2
  fi
  xmllint --xpath "$i" $1
  echo
fi
