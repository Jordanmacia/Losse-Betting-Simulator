#!/bin/bash
#Credits: Jordan Macia | hack4u.io

#This script is my first project and has been created with the help of an introductory course to Linux (Bash) from Hack4u.io academy. This script is a command-line program written in Bash that simulates a betting game using the Martingale or InverseLaBrouchere technique. It allows the user to enter the amount of money they want to play with and choose between two options of game techniques. The program performs the calculations and corresponding bets according to the selected technique until the player runs out of money or decides to exit the game. At the end of the game, it displays the total number of plays, the maximum amount of money that could have been won, and a list of consecutive bad plays that have occurred. It is important to note that the purpose of this script is purely educational and recreational, and it does not seek to encourage or promote gambling or gambling addiction behaviors. It is always important to engage in responsible gambling and be aware of the associated risks. In fact, this script demonstrates precisely that betting houses always win in the long run, so it is better not to take unnecessary risks.


#Colors
greenColour="\e[0;32m\033[1m"
darkGreenColour="\e[0;32m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


#Ctrl_C
function ctrl_c(){
echo -e "\n\n${redColour}[!] Exiting...${endColour}\n"
tput cnorm;exit 1
}

#HelpPanel
function helpPanel(){
echo -e "\n${yellowColour}[+]${endColour}${grayColour} Usage: ${endColour}"
echo -e "\n\t${grayColour}-m) ${endColour}${greenColour} Money${endColour}${grayColour} you want to play with 🤑 ${endColour}"
echo -e "\n\t${grayColour}-t) ${endColour}${blueColour} Technique${endColour}${grayColour} you want to use 🔧 (${yellowColour} Martingale${endColour} | ${yellowColour}InverseLaBrouchere${endColour} ) ${grayColour}\n${endColour}"
}

#Martingale
function martingale() {
    sleep 1
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Available balance: ${darkGreenColour}$money $ ${endColour}\n"
    sleep 2

    while true; do
        echo -ne "\t${yellowColour}- ${endColour}${grayColour}Enter the amount you want to bet ${yellowColour}-> ${endColour}" && read initial_bet
        if (( initial_bet <= money )); then
            break
        fi
        echo -e "\t${redColour}The entered amount is higher than the available balance! ${endColour}"
    done
    sleep 1.5

    while true; do
        echo -ne "\t${yellowColour}- ${endColour}${grayColour}What do you want to constantly bet on? (even/odd) ${yellowColour}-> ${endColour}" && read par_impar
        if [[ "$par_impar" == "even" || "$par_impar" == "odd" ]]; then
            break
        fi
        echo -e "\t${redColour}Syntax error! ${endColour}"
    done
    tput civis
    error=''
    backup_bet=$initial_bet
    play_counter=0
    bad_plays=" "
    max_win=0
   
	while true; do
	money=$(($money-$initial_bet))
	random_number="$((RANDOM % 37))"
	if [ ! "$money" -lt -0 ]; then	
            if [ "$money" -gt "$max_win" ]; then
 			max_win="$money"
	    fi
		if [ "$par_impar" == "even" ]; then	
			if [ "$((random_number % 2))" -eq 0 ]; then
				if [ "$random_number" -eq 0 ]; then
					initial_bet=$(($initial_bet*2))
					bad_plays+="$random_number "
				else
					reward=$(($initial_bet*2))
					money=$(($money+$reward))
					initial_bet=$backup_bet
					bad_plays=" "
				fi
			else
				initial_bet=$(($initial_bet*2))
				bad_plays+="$random_number "
			fi

		else
			if [ "$((random_number % 2))" -ne 0 ]; then
				reward=$(($initial_bet*2))
				money=$(($money+$reward))
				initial_bet=$backup_bet
				bad_plays=" "
			else
				initial_bet=$(($initial_bet*2))
				bad_plays+="$random_number "
			fi
		fi        
     else
     	echo -e "\n ${redColour}[!] YOU HAVE RUN OUT OF MONEY...${endColour}\n"
     	echo -e "${yellowColour}[+]${endColour}${greyColour} There have been a total of ${endColour}${yellowColour}$play_counter${endColour}${greyColour} plays${endColour}"
     	echo -e "${yellowColour}[+]${endColour}${greyColour} The maximum amount of money that could have been won is ${endColour}${yellowColour}$max_win${endColour}${greyColour} $ ${endColour}"
    	echo -e "${yellowColour}[+]${endColour}${greyColour} The consecutive bad plays that have occurred will now be displayed: \n\n\t\t\t\t[${endColour}${redColour}$bad_plays${endColour}]\n"
    	
     	tput cnorm;exit 0
     	
     fi
     let play_counter+=1
done
tput cnorm
}

#InverseLaBrouchere
function inverseLaBrouchere() {
    sleep 1

    while true; do
        echo -ne "\t${yellowColour}- ${endColour}${grayColour}What do you want to constantly bet on? (even/odd) ${yellowColour}-> ${endColour}" && read par_impar
        if [[ "$par_impar" == "even" || "$par_impar" == "odd" ]]; then
            break
        fi
        echo -e "\t${redColour}Syntax error!${endColour}"
    done

    declare -a my_sequence=(1 2 3 4)
    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
    total_plays=0
    bet_to_renew=$(($money + 50))
    max_money_won=$money
	while true; do
	random_number=$(($RANDOM % 37))
	money=$(($money - $bet))

	if [ "$par_impar" == "even" ]; then
		if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
			reward=$(($bet * 2))
			let money+=$reward

			if [ $money -gt $bet_to_renew ]; then
				bet_to_renew=$(($bet_to_renew + 50))
				my_sequence=(1 2 3 4)
				bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
			elif [ $money -lt $(($bet_to_renew - 100)) ]; then
				bet_to_renew=$((bet_to_renew - 50))
				my_sequence+=($bet)
				my_sequence=(${my_sequence[@]})
				if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
					bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
				elif [ "${#my_sequence[@]}" -eq 1 ]; then
					bet=${my_sequence[0]}
				fi
			fi
		else
			if [ "$random_number" -eq 0 ]; then
				unset my_sequence[0]
				unset my_sequence[-1] 2>/dev/null
				my_sequence=(${my_sequence[@]})
			fi
			if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
				bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
			elif [ "${#my_sequence[@]}" -eq 1 ]; then
				bet=${my_sequence[0]}
			fi
			if [ "${#my_sequence[@]}" -eq 0 ]; then
				my_sequence=(1 2 3 4)
				bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
			fi
		fi
	elif [ "$par_impar" == "odd" ]; then
		if [ "$(($random_number % 2))" -ne 0 ]; then
			reward=$(($bet * 2))
			let money+=$reward

			if [ $money -gt $bet_to_renew ]; then
				bet_to_renew=$(($bet_to_renew + 50))
				my_sequence=(1 2 3 4)
				bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
			elif [ $money -lt $(($bet_to_renew - 100)) ]; then
				bet_to_renew=$((bet_to_renew - 50))
				my_sequence+=($bet)
				my_sequence=(${my_sequence[@]})
				if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
					bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
				elif [ "${#my_sequence[@]}" -eq 1 ]; then
					bet=${my_sequence[0]}
				fi
			fi
		else
			if [ "$random_number" -eq 0 ]; then
				unset my_sequence[0]
				unset my_sequence[-1] 2>/dev/null
				my_sequence=(${my_sequence[@]})
			fi
			if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
				bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
			elif [ "${#my_sequence[@]}" -eq 1 ]; then
				bet=${my_sequence[0]}
			fi
			if [ "${#my_sequence[@]}" -eq 0 ]; then
				my_sequence=(1 2 3 4)
				bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
			fi
		fi
	fi

	if [ $money -gt $max_money_won ]; then
		max_money_won=$money
	fi

	if [ "$money" -le 0 ]; then
		echo -e "\n ${redColour}[!] YOU HAVE RUN OUT OF MONEY...${endColour}\n"
		echo -e "${yellowColour}[+]${endColour}${greyColour} There have been a total of ${endColour}${yellowColour}$total_plays${endColour}${greyColour} total plays${endColour}"
		echo -e "${yellowColour}[+]${endColour}${greyColour} The maximum amount of money that could have been won is ${endColour}${yellowColour}$max_money_won${endColour}${greyColour} $ ${endColour}"
		exit 1
	fi
	let total_plays+=1
done
}


#Main
trap ctrl_c INT

# Parameters
while getopts "m:t:h" arg; do
    case $arg in
        m)
            money=$OPTARG
            ;;
        t)
            technique=$OPTARG
            ;;
        h)
            ;;
    esac
done

if [ $money ] && [ $technique ]; then
    if [ $technique == "Martingale" ]; then
        martingale
    elif [ $technique == "InverseLaBrouchere" ]; then
        inverseLaBrouchere
    else
        echo -e "\n${redColour}[!] The technique${endColour} ${yellowColour}$technique${endColour} ${redColour}does not exist${endColour}\n"
        helpPanel
    fi
else
    helpPanel
fi

