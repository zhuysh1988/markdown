

function bak_file(){ 
  cp $1 $1.`date +%s`
}

alias bak_file=bak_file
alias jgrep="egrep -v '^$|^#' "