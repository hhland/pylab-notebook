# spellcheck.awk -- interactive spell checker
#
# AUTHOR: Dale Dougherty
#
# Usage: nawk -f spellcheck.awk [+dict] file 
# This has been edited to work with gawk or nawk.
# (Use spellcheck as name of shell program) 
# SPELLDICT = "dict" 
# SPELLFILE = "file"

# BEGIN actions perform the following tasks: 
#	1) process command line arguments
#	2) create temporary filenames
#	3) execute spell program to create wordlist file
#	4) display list of user responses

BEGIN { 
# Process command line arguments
# Must be at least two args -- nawk and filename
	if (ARGC > 1) {
	# if more than two args, second arg is dict 
		if (ARGC > 2) {
		# test to see if dict is specified with "+"  
		# and assign ARGV[1] to SPELLDICT
			if (ARGV[1] ~ /^\+.*/) 
				SPELLDICT = ARGV[1]
			else 
				SPELLDICT = "+" ARGV[1]
		# assign file ARGV[1] to SPELLFILE 
			SPELLFILE = ARGV[2]
		# delete args so awk does not open them as files
			delete ARGV[1]
			delete ARGV[2]
		}
	# not more than two args
		else {
		# assign file ARGV[2] to SPELLFILE 
			SPELLFILE = ARGV[1]
		# test to see if local dict file exists
			if (! system ("test -r dict")) {
			# if it does, ask if we should use it
				printf ("Use local dict file? (y/n)")	
				getline reply <"/dev/tty"
			# if reply is yes, use "dict" 
				if (reply ~ /[yY](es)*/){
					SPELLDICT = "+dict"
				}
			}
		}
	} # end of processing args > 1 
	# if args not > 1, then print shell-command usage 
	else {
		print "Usage: spellcheck [+dict] file"
		exit
	}
# end of processing command line arguments

# create temporary file names, each begin with sp_
	wordlist = "sp_wordlist"
	spellsource = "sp_input"
	spellout = "sp_out"

# copy SPELLFILE to temporary input file
	system("cp " SPELLFILE " " spellsource)

# now run spell program; output sent to wordlist
	print "Running spell checker ..."
	if (SPELLDICT)
		SPELLCMD = "spell " SPELLDICT " "
	else
		SPELLCMD = "spell "
	system(SPELLCMD spellsource " > " wordlist )

# test wordlist to see if misspelled words turned up
	if ( system("test -s " wordlist ) ) {
	# if wordlist is empty, (or spell command failed), exit
		print "No misspelled words found."
		exit
	}	

# assign wordlist file to ARGV[1] so that awk will read it.	
	ARGV[1] = wordlist

# display list of user responses 
	responseList = "Responses: \n\tChange each occurrence," 
	responseList = responseList "\n\tGlobal change," 
	responseList = responseList "\n\tAdd to Dict,"  
	responseList = responseList "\n\tHelp," 
        responseList = responseList "\n\tQuit" 
	responseList = responseList "\n\tCR to ignore: "
	printf("%s", responseList)

} # end of BEGIN procedure

# main procedure, executed for each line in wordlist.
#	Purpose is to show misspelled word and prompt user
#	for appropriate action.

{
# assign word to misspelling
	misspelling = $1 
	response = 1
	++word
# print misspelling and prompt for response
	while (response !~ /(^[cCgGaAhHqQ])|^$/ ) {
		printf("\n%s - Found %s (C/G/A/H/Q/):", word, misspelling)
		getline response < "/dev/tty"
		print response "$$"
	}
# now process the user's response
# CR - carriage return ignores current word 
# Help
	if (response ~ /[Hh](elp)*/) {
	# Display list of responses and prompt again.
		printf("%s", responseList)
		printf("\n%s - Found %s (C/G/A/Q/):", word, misspelling)
		getline response <"/dev/tty"
	}
# Quit
	if (response ~ /[Qq](uit)*/) exit
# Add to dictionary
	if ( response ~ /[Aa](dd)*/) { 
		dict[++dictEntry] = misspelling
	}
# Change each occurrence
	if ( response ~ /[cC](hange)*/) {
	# read each line of the file we are correcting
		newspelling = ""; changes = ""
		while( getline < spellsource > 0){
		# call function to show line with misspelled word
		# and prompt user to make each correction 
			make_change($0)
		# all lines go to temp output file
			print > spellout
		}	
	# all lines have been read 
	# close temp input and temp output file
		close(spellout)
		close(spellsource)
	# if change was made
		if (changes){ 
		# show changed lines
			for (j = 1; j <= changes; ++j)
				print changedLines[j]
			printf ("%d lines changed. ", changes) 
		# function to confirm before saving changes
			confirm_changes()
		}
	}
# Globally change
	if ( response ~ /[gG](lobal)*/) {
	# call function to prompt for correction
	# and display each line that is changed.
	# Ask user to approve all changes before saving.
		make_global_change()
	}	
} # end of Main procedure

# END procedure makes changes permanent.
# It overwrites the original file, and adds words
# to the dictionary.
# It also removes the temporary files.

END {
# if we got here after reading only one record, 
# no changes were made, so exit.
	if (NR <= 1) exit
# user must confirm saving corrections to file
	while (saveAnswer !~ /([yY](es)*)|([nN]o*)/ ) {
		printf "Save corrections in %s (y/n)? ", SPELLFILE
		getline saveAnswer <"/dev/tty"
	}
# if answer is yes then mv temporary input file to SPELLFILE
	if (saveAnswer ~ /^[yY]/)
		system("mv " spellsource " " SPELLFILE) 
# if answer is no then rm temporary input file
	if (saveAnswer ~ /^[nN]/)
		system("rm " spellsource) 

# if words have added to dictionary array, then prompt
# to confirm saving in current dictionary. 
	if (dictEntry) {
		printf "Make changes to dictionary (y/n)? "
		getline response <"/dev/tty"
		if (response ~ /^[yY]/){
		# if no dictionary defined, then use "dict"
			if (! SPELLDICT) SPELLDICT="dict"
		
		# loop through array and append words to dictionary
			sub(/^\+/,"",SPELLDICT)
			for ( item in dict )
				print dict[item] >> SPELLDICT
		# sort dictionary file 
			system("sort " SPELLDICT "> tmp_dict")
			system("mv " "tmp_dict " SPELLDICT)
		}
	}
# remove word list.
	system("rm" " sp_wordlist")
} # end of END procedure

# function definitions

# make_change -- prompt user to correct misspelling 
#		 for current input line.  Calls itself
# 		 to find other occurrences in string.
# 	stringToChange -- initially $0; then unmatched substring of $0
# 	len -- length from beginning of $0 to end of matched string 
# Assumes that misspelling is defined. 

function make_change (stringToChange,len,  line, OKmakechange) {

# match misspelling in stringToChange; otherwise do nothing 
  if ( match(stringToChange, misspelling) ){
  # Display matched line 
	printstring = $0
	gsub(/\t/," ",printstring)
	print printstring
	carets = "^"
	for (i = 1; i < RLENGTH; ++i)
		carets = carets "^"
	if (len)
		FMT = "%" len+RSTART+RLENGTH-2 "s\n"
	else
		FMT = "%" RSTART+RLENGTH-1 "s\n"
	printf(FMT, carets)
  # Prompt user for correction, if not already defined
	if (! newspelling) {
		printf "Change to:"
		getline newspelling <"/dev/tty"
	}
  # A carriage return falls through
  # If user enters correction, confirm  
	while (newspelling && ! OKmakechange) {
		printf ("Change %s to %s? (y/n):", misspelling, newspelling)
		getline OKmakechange <"/dev/tty"
		madechg = ""
	# test response
		if (OKmakechange ~ /[yY](es)*/ ) {
		# make change (first occurrence only)
			madechg = sub(misspelling, newspelling, stringToChange)
		}
		else if ( OKmakechange ~ /[nN]o*/ ){
			# offer chance to re-enter correction 
			printf "Change to:"
			getline newspelling <"/dev/tty"
			OKmakechange = ""
		}
	} # end of while loop

   # if len, we are working with substring of $0
	if (len) {
	# assemble it
		line = substr($0,1,len-1)
		$0 = line stringToChange
	}
	else {
		$0 = stringToChange
		if (madechg) ++changes
	}

   # put changed line in array for display
	if (madechg) 
		changedLines[changes] = ">" $0

   # create substring so we can try to match other occurrences
	len = len+RSTART + RLENGTH
	part1 = substr($0,1,len-1)
	part2 = substr($0,len)
   # calls itself to see if misspelling is found in remaining part 
 	make_change(part2,len) 

  } # end of if

} # end of make_change()

# make_global_change --
#		prompt user to correct misspelling 
#		for all lines globally.  
# 	        Has no arguments
# Assumes that misspelling is defined. 

function make_global_change(    newspelling, OKmakechange, changes) {

# prompt user to correct misspelled word
   printf "Globally change to:"
   getline newspelling <"/dev/tty"

# carriage return falls through
# if there is an answer, confirm 
   while (newspelling && ! OKmakechange) {
		printf ("Globally change %s to %s? (y/n):", misspelling, newspelling)
		getline OKmakechange <"/dev/tty"
	# test response and make change
		if (OKmakechange ~ /[yY](es)*/ ) {
		# open file, read all lines 
			while( getline < spellsource > 0){
			# if match is found, make change using gsub
			# and print each changed line.
				if ($0 ~ misspelling) {
					madechg = gsub(misspelling, newspelling)
					print ">", $0
					changes += 1  # counter for line changes
				}
			# write all lines to temp output file
				print > spellout
			} # end of while loop for reading file

		# close temporary files
			close(spellout)
			close(spellsource)
		# report the number of changes	
			printf ("%d lines changed. ", changes) 
		# function to confirm before saving changes
			confirm_changes()
		} # end of if (OKmakechange ~ y) 

	# if correction not confirmed,  prompt for new word
		else if ( OKmakechange ~ /[nN]o*/ ){
			printf "Globally change to:"
			getline newspelling <"/dev/tty"
			OKmakechange = ""
		}

	} # end of while loop for prompting user for correction

} # end of make_global_change()

# confirm_changes --  
#		confirm before saving changes

function confirm_changes(  savechanges) {
# prompt to confirm saving changes
	while (! savechanges ) {
		printf ("Save changes? (y/n)")
		getline savechanges <"/dev/tty"
	}
# if confirmed, mv output to input
	if (savechanges ~ /[yY](es)*/)
		system("mv " spellout " " spellsource) 
}
