BEGIN { FS = ","   # comma-separated fields
	# assign width and height of bitmap
	WIDTH = 12
	HEIGHT = 12
	# loop to load entire array with "O"
	for (i = 1; i <= WIDTH; ++i)
		for (j = 1; j <= HEIGHT; ++j)
			bitmap[i,j] = "O"
}
# read input of the form x,y. 
{
	# found that bitmap[$0] would not work.
	# so assign to variables.
	coordx = $1
	coordy = $2
	# assign "X" to that element of array 
	bitmap[coordx,coordy] = "X"
}
# at end output multidimensional array
END {
	for (i = 1; i <= WIDTH; ++i){
		for (j = 1; j <= HEIGHT; ++j)
			printf ("%s", bitmap[i,j] )
		# after each row, print newline
		printf("\n")	
	}
}
