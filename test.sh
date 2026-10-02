#!/bin/bash

<<comment
find the service is running

read -p "enter the service name :" service 

if systemctl status "$service"; then
	echo "$service : running"
else
	echo "$service : not running"
fi
comment


<<comment
find larg files



read -p "enter th direcotry name : " dir 

if [ ! -d "$dir" ]; then
	echo "the directory not exist"
	exit 0
fi

find "$dir" -type f -size +1M -exec du -h {} \;
comment


<<comment
process investigation


echo "top 5 process in cpu"
echo 
ps aux --sort=-%cpu | head -6
echo

echo "top 5 process in ram"
echo 
ps aux --sort=-%mem | head -6
echo 

echo "find the pid of python"
echo 
ps aux | grep "python"
echo 

echo "know about the process"
echo 
ps -fp 264
comment



<<comment
port troubleshooting

echo "check the service"

read -p "enter the website name : " site 

if curl -Is "$site" >/dev/null 2>&1; then
	echo "$site : running"
else
	echo "$site : not running"
fi
comment


<<comment
find old file

file=(find /home -type f -size +50M -mtime +7 -exec du -h {} \;)
echo "$file"
comment


<<comment
backup code



source=$1
backup_dir="/tmp/backups"
date=(date)

mkdir -p "$backup_dir"

tar -czf "$backup_dir/backup_$date.tar.gz" "$source"

echo "backup created : $backup_dir/backup_$date.tar.gz"
comment


<<comment
memory investigation



free -h | awk '/Mem:/ {
	print "total memory :", $2
	print "used memory :", $3
	print "free memory :", $4
	print "available memory :", $5
comment


<<comment
program for make the backup code


echo "backup script started"

read -p "Enter the source directory: " src
read -p "Enter the backup directory: " back

if [ ! -d "$src" ]; then
    echo "The source directory does not exist"
    exit 1
fi

if [ ! -d "$back" ]; then
    echo "Backup directory not found..."
    echo "Creating the directory..."
    mkdir -p "$back"
fi

date=$(date +"%Y-%m-%d_%H-%M-%S")

echo "Making backup..."

tar -czf "$back/backup_$date.tar.gz" "$src"

if [ $? -eq 0 ]; then
    echo "Backup created successfully"
    echo "Backup location: $back/backup_$date.tar.gz"
else
    echo "Backup failed"
    exit 1
fi
comment



<<comment
connect mysql to bash
comment

echo 
echo "---- MYSL BASH MANAGER ----"
echo


read -p "enter the response to connect mysql to machine (y/n) : " response

if [[ "$response" != "y" && "$response" != "Y" ]]; then
	echo "mysql connnection failed"
	exit 1
fi

echo
echo "checking mysql client ...."
echo

if ! command -v mysql &> /dev/null; then
	echo "my sql client is not installed"
	exit 1
fi

echo "mysql client found .."
echo 
echo "checking mysql service...."
echo

if ! sudo systemctl is-active --quiet mysql; then
	echo "error : mysql is not running"
	exit 1
fi

echo "mysql is running"
echo 
echo "connecting to mysql"
sleep 1

mysql -u admin_mysql -p

if [ $? -eq 0 ]; then
    echo "MySQL connection successful."
else
    echo "MySQL connection failed."
    exit 1
fi

