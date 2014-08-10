#!/bin/bash
# s13.sh
#1  with v (vim)
d="s13"
f="(
http://img514.imageshack.us/img514/4946/10529673ey8.png
http://my240.epijunkie.com/images/6/6c/Fsm-s13-brakebooster.jpg
http://www.garage411.com/images/Nissan/S13/Accessories/HeadlightDoors29.gif
http://img134.imageshack.us/img134/502/interiortf1.jpg
http://mildman.datsunprojects.org/otherimg/vacsys.jpg
http://www.impactblue.org/content/ca18det-ref/img/
$0
)"
case $1 in
v)  	vim $0
	exit 0;;
*)	printf "
	usage: $0 v
	v is there just to annoy you (#1)
	" #you entered a password without being prompted for it!
;;
esac
#g(){
mkdir $d &&cd $d
for ((f=0;f++;f=${#list}))
do	wget -r ${l[$f]}
done
#}
#ssh guest@89.11.170.69 $(g)
