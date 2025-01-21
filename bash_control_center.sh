#!/bin/bash

GREEN='\e[0;32m'
YELLOW='\e[0;33m'
RED='\e[0;31m'
BLUE='\033[34m'
BLUE_UNDERLINE='\e[4;34m'
RESET='\033[0m'

PS3='Please enter your choice: '
while true; do
    clear
    echo -e "=========== ${BLUE}${BLUE_UNDERLINE}Bash Control Center${RESET} ==========="
    echo "1) Show all running processes (name and PID only)"
    echo "2) Kill a process"
    echo "3) Show PC specs"
    echo "4) Show active services"
    echo "5) Search File"
    echo "q) Quit"
    echo -e -n "Please enter your choice: ${GREEN}"
    read choice
    echo -e "${RESET}"

    case $choice in
        1)
            ps -e -o pid,comm
            ;;
        2)
            read -p "Please write the PID of the process you want to kill: " killchoice

            process_name=$(ps -p $killchoice -o comm=)

            if [ -z "$process_name" ]; then
                echo "No process found with PID $killchoice."
            else
                read -p "Are you sure you want to delete: $process_name (PID $killchoice)? (y/n)" confirmation

                if [[ $confirmation == [Yy] ]]; then
                    kill $killchoice
                    if [ $? -eq 0 ]; then
                        echo "Process $pro:cess_name (PID $killchoice) has been killed."
                    else
                        echo "Failed to kill the process."
                    fi
                else
                    echo "Process kill aborted."
                fi
            fi
            ;;
        3)
            echo -e "${BLUE}Cpu:${RESET}"
            lscpu | sed -nr '/Model name/ s/.*:\s*(.*) @ .*/\1/p'

            echo -e "${BLUE}Storage:${RESET}"
            df -h
            ;;
        4)
            echo -e "${BLUE}Active Services:${RESET}"
            systemctl list-units --type=service --state=active
            ;;
        5)
            echo -e -n "Please enter the file name (without extension) to search for: ${GREEN}"
            read filename
            echo -e "${BLUE}Searching for files matching: ${RESET}$filename\n"

            find / -type f -iname "$filename*" -exec ls -lh --time=creation {} \; 2>/dev/null | \
            sort -k 6,7 | \
            while read -r line; do
                echo "$line" | awk '{print "File: " $9 "\nSize: " $5 "\nCreation Time: " $6 " " $7 " " $8 "\n"}'
            done
            ;;
        q)
            echo -e "${YELLOW}Exiting...${RESET}"
            break
            ;;
        *)
            echo -e "${RED}Invalid option!${RESET}"
            ;;
    esac
    echo -e "\n${YELLOW}Press [Enter] to continue...${RESET}"
    read 
done

