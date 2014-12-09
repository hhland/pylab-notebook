$1 ~ /^\.so/ { gsub(/"/,"", $2)
		system("cat " $2)
		next
		}
{print}
