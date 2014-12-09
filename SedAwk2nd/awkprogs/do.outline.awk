gawk '# do.outline -- number headings in chapter.
{
gsub(/"/,"")
}
/^\.Se/ {
	sub(/^\.Se /, "Chapter ") 
	ch = $2
	ah = 0
	bh = 0
	print
	next
}
/^\.Ah/ {
	sub(/^\.Ah /,"\t " ch "." ++ah " ") 
	bh = 0
	print
	next
}
/^\.Bh/ {
	sub(/^\.Bh /,"\t\t " ch "."  ah "." ++bh " ")
	print
}' $*
