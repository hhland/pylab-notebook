awk -F, '{
 print $4 ", " $0
 }' $* |
sort |
awk -F, '
$1 == LastState {
 print "\t" $2
}
$1 != LastState {
 LastState = $1
 print $1
}'