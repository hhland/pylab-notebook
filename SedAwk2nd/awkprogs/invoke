nawk -v CMDFILE="uucp_commands"  '# invoke -- menu-based command generator
# first line in CMDFILE is the title of the menu
# subsequent lines contain: $1 - Description; $2 Command to execute
BEGIN { FS = ":" 
# process CMDFILE, reading items into menu array 
  while (getline < CMDFILE > 0 ) {
	# read title
	if (! title) { 
		title = $1 
		continue
	}
	# load array
	++sizeOfArray
	# array of menu items
	menu[sizeOfArray] = $1
	# array of commands associated with items
	command[sizeOfArray] = $2
	} 
  # call function to display menu items and prompt
  display_menu()
}
# Applies to user response to prompt
{
   # test value of user response
   if ($1 > 0 && $1 <= sizeOfArray) {
	# print command that is executed
	printf ("Executing ...")
	print command[$1] 
	# then execute it. 
	system(command[$1])
	printf("<Press Return to continue>")
 	# wait for input before displaying menu again
	getline
   }
   else 
	exit	
   # re-display menu 
   display_menu()
}

function display_menu() {
	# clear screen -- if clear does not work, try "cls"
	system("clear")
	# print title, list of items, exit item, and prompt
	print "\t" title
	for ( i = 1; i <= sizeOfArray; ++i)
		print "\t" i ". " menu[i]
	print "\t" i ". Exit"
	printf("Choose one:")
}' -
