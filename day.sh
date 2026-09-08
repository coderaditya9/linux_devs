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



