#!/bin/bash

echo "What is the domain?: "
read domain

echo "What is the username?: "
read username

echo "What is the password?: "
read password

echo "What is the ip address?: "
read ip_address

# a script to help me with remembering the syntax for AD enumeration for use in bloodhound

bloodhound-python -d $domain -u $username -p $password -gc $domain -c all -ns $ip_address