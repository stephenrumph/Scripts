#!/bin/bash

# Help function
show_help() {
  echo "Usage: $0"
  echo
  echo "Choose one of the following options:"
  echo "  1 - Choose a custom username (e.g. root, user)"
  echo "  2 - Choose a well known wordlist"
  echo "  3 - Use your own wordlist"
  echo "  h - Show Help"
}

# ---------- USERNAME SECTION ----------
echo -e "Choose a username option:\n1 - Single Username\n2 - Well known wordlists\n3 - Type in your own wordlist\nh - Help"
read -p "Enter 1, 2, 3 or h: " username_choice

if [[ $username_choice =~ ^[hH]$ || $username_choice == "--help" ]]; then
  show_help
  exit 0
fi

case $username_choice in
  1)
    read -p "Enter the username you want to use: " username
    echo "You entered: $username"
    ;;
  2)
    echo -e "Choose from these well-known wordlists:\n1 - /usr/share/wordlists/rockyou.txt\n2 - /usr/share/john/john.lst\n3 - /usr/share/seclists/Usernames/top-usernames-shortlist.txt"
    read -p "Enter 1, 2, or 3: " wordlist_choice
    case $wordlist_choice in
      1) username_wordlist="/usr/share/wordlists/rockyou.txt" ;;
      2) username_wordlist="/usr/share/john/john.lst" ;;
      3) username_wordlist="/usr/share/seclists/Usernames/top-usernames-shortlist.txt" ;;
      *) echo "Invalid selection." && exit 1 ;;
    esac
    echo "You selected: $username_wordlist"
    ;;
  3)
    read -p "Enter the full path to your username wordlist: " username_wordlist
    if [[ -f $username_wordlist ]]; then
      echo "Using custom wordlist: $username_wordlist"
    else
      echo "File not found: $username_wordlist"
      exit 1
    fi
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac

# ---------- PASSWORD SECTION ----------
echo -e "\nChoose a password option:\n1 - Well known wordlists\n2 - Type in your own wordlist\n3 - Use single password\nh - Help"
read -p "Enter 1, 2, 3 or h: " password_choice

if [[ $password_choice =~ ^[hH]$ || $password_choice == "--help" ]]; then
  show_help
  exit 0
fi

case $password_choice in
  1)
    echo -e "Select password wordlist:\n1 - /usr/share/wordlists/rockyou.txt\n2 - /usr/share/john/john.lst"
    read -p "Enter 1 or 2: " pwlist_choice
    case $pwlist_choice in
      1) password_wordlist="/usr/share/wordlists/rockyou.txt" ;;
      2) password_wordlist="/usr/share/wordlists/john.lst" ;;
      *) echo "Invalid selection." && exit 1 ;;
    esac
    echo "Using password wordlist: $password_wordlist"
    ;;
  2)
    read -p "Enter the full path to your password wordlist: " password_wordlist
    if [[ -f $password_wordlist ]]; then
      echo "Using custom password wordlist: $password_wordlist"
    else
      echo "File not found: $password_wordlist"
      exit 1
    fi
    ;;
  3)
    read -p "Enter the single password to use: " password
    echo "You entered: $password"
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac



read -p "What is the IP address or domain?: " ip_choice

# Build Hydra command based on what was chosen
if [[ -n "$username_wordlist" ]]; then
  user_arg="-L $username_wordlist"
elif [[ -n "$username" ]]; then
  user_arg="-l $username"
else
  echo "Username input missing!"
  exit 1
fi

if [[ -n "$password_wordlist" ]]; then
  pass_arg="-P $password_wordlist"
elif [[ -n "$password" ]]; then
  pass_arg="-p $password"
else
  echo "Password input missing!"
  exit 1
fi


read -p "Enter the full web path to the login form (e.g. /vulnerabilities/brute/): " login_path

full_target="${ip_choice}${login_path}"
read -p "Enter the port (default is 80, e.g. 80, 42001): " port

echo -e "\nRunning Hydra...\n"
hydra $user_arg $pass_arg $ip_choice -s $port http-post-form "$login_path:username=^USER^&password=^PASS^&Login=Login:S=Welcome" -t 1 -w 5 -f -o hydra_results.txt
