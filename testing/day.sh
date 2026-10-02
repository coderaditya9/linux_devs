#!/bin/bash

<<comment
program for disk usage

disk=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$disk" -gt 80 ]; then
	echo "warning : disk usage is high"
else
	echo "the disk usage is normal"
fi
comment


<<comment
check website for up or down


websites=("google.com" "github.com" "amazon.com" "youtube.com" "wikipedia.org")

for site in "${websites[@]}"
do
	if curl -Is "https://$site" >/dev/null 2>&1
	then
		echo "$site : UP"
	else
		echo "$site : DOWN"
	fi
done
comment


<<comment
program for check the service



read -p "enter the service name to check : " service 

if systemctl is-active "$service"
then
	echo "$service : active"
	exit 
else
	echo "service stopped ..."
	sleep 3
	echo "service restarting"
	sudo systemctl restart $service
	sleep 2
	echo "service restart successfully"
fi
comment


<<comment
linux system health kit



echo "---- LINUX SYSTEM HEALTH KIT ----"
echo 

cpu=$(top -bn1 | grep "Cpu(s)")

disk=$(df -h / | awk 'NR==2 {print $5}')

ram=$(free -h)

uptime=$(uptime)

ip=$(hostname -I)

process=$(ps aux --sort=-%cpu | head -n 6)


echo "---- .REPORT. ----"
echo
echo "total cpu usage       :       $cpu"
echo "total disk usage      :      $disk"
echo "total ram suage       :       $ram"
echo "uptime	            :       $uptime"
echo "ip address            :       $ip"
echo "consuming cpu process : $process"
comment

<<comment
code for devops monitoring tool

while true
do

	echo "-----DEVOPS MONITORING TOOL----"
	echo 
	echo "1. CPU USAGE"
	echo "2. RAM USAGE"
	echo "3. DISK USAGE"
	echo "4. RUNNING service"
	echo "5. WEBSITE AVAILABILITY"
	echo "6. EXIT"

	read -p "enter the choice name : " choice

	if [ "$choice" == 1 ]; then
		echo "check cpu usage"
		echo 
		cpu=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8 "%"}')
		echo "CPU USAGE : $cpu"
		echo

	elif [ "$choice" == 2 ];
	then
		echo "check ram usage"
		echo
		ram=$(free | awk '/Mem:/ {printf "%.2f%%\n", $3/$2 * 100}')
		echo "RAM USAGE :  $ram"
		echo

	elif [ "$choice" == 3 ]; then
		echo "check disk usage"
		echo 
		disk=$(df -h / | awk 'NR==2 {print $5}')
		echo "DISK USAGE : $disk"
		echo

	elif [ "$choice" == 4 ]; then
		echo "runninng service"
		for ((i=1; i<=3; i++))
		do
			read -p "enter the service name : " service 

			if systemctl is-active --quiet "$service"
			then
				echo "$service : RUNNING"
				echo
			else
				echo "$service : NOT RUNNING"
				echo
			fi
		done

	elif [ "$choice" == 5 ]; then
		echo "website availability"
		echo 
		for ((i=1; i<=5; i++))
		do
			read -p "enter the website name : " site

			if curl -Is "https://$site" >/dev/null 2>&1
			then
				echo "$site : REACHEABLE"
				echo
			else
				echo "$site : NOT REACHEABLE"
				echo

			fi
		done

	elif [ "$choice" == 6 ]; then
		echo "program exited successfully"
		exit 
	else
		echo "invalid choice"
		exit 0
	fi
done
comment

<<comment
program for consuning 5 direcotry

dir=(sudo du -h --max-depth=1 /var 2>/dev/null | sort -hr | head -n 6)
echo "$dir"
comment


<<comment
find larger file than 100 mb from home directory


dir=(find /home -type f -size +100M -exec ls -lh {} \;)

echo "$dir"
comment


<<comment
program for find files


file=(find /var/log -type f -mtime +7)
echo "$file"
comment


<<comment
display the last 20 line



read -p "enter the log file name : " logfile

if [ ! -f "$logfile" ]; then
	echo "the log file not exist in the folder"
	exit 0
fi

error=(grep -c "ERROR" "$logfile" | tail -5)
echo "last 20 error line:"
echo "$error"
comment


<<comment
print service is running


read -p "enter the service name : " service 

if systemctl is-active --quiet "$service"
then
	echo "$service : running"
else
	echo "$service : not running"
fi
comment


<<comment
check ssh is running


read -p "enter the service name : " service

if systemctl status "$service"
then
	echo "$service : running"
else
	echo "$service : not running"
fi
comment


<<comment
check the website is reacheable 


read -p "enter the website name : " site 

if curl -Is "$site" > /dev/null 2>&1
then
	echo "$site : reacheable"
else
	echo "$site : not reacheable"
fi
comment


<<comment
check port 80 is listening on linux machine


if sudo ss -tulnp | grep -q ":80"; then
	echo "the port 80 is listening"
else
	echo "port 80 is not listening"
fi
comment


<<comment
find the most common ip address



read -p "enter the logfile name : " logfile

if [ ! -f "$logfile" ]; then
	echo "the log file not exist in the system"
	exit 0
fi

ip=$(awk '{print $1}' "$logfile" | sort | uniq -c | sort -nr | head -1)
echo "$ip"
comment


<<comment
create a backup of /var/log



date=$(date +%Y-%m-%d)

sudo tar -czf "var-log-backup-$date.tar.gz" /var/log

echo "backup created successfully : var-log-backup-$date.tar.gz"
comment


<<comment
find large file in /home
comment


file=$(find /home -type f -size +100M -exec ls -lh {} \;)

echo "$file"

