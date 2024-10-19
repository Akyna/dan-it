### Exercise 1: Hello World
Write a Bash script that simply echoes "Hello, World!" when executed.
```bash
#!/bin/bash

echo "Hello World!"
```
### Exercise 2: User Input
Create a script that asks the user for their name and then greets them using that name.
```bash
echo -n "Enter your name: "
IFS=' ' read -r name
echo "Hello $name"
```
### Exercise 3: Conditional Statements
Write a script that checks if a file exists in the current directory. If it does, print a message saying it exists; otherwise, print a message saying it doesn't exist.
```bash
echo -n "Enter file name: "
read -r file_name
if [ -f "$file_name"  ]; then
  echo "File exists"
  else
    echo "File doesn't exist."
fi
```
### Exercise 4: Looping
Create a script that uses a loop to print numbers from 1 to 10.
```bash
for i in {1..10} ; do
    echo "$i"
done
for (( i = 1; i <= 10; i++ )); do
    echo "$i"
done
```
### Exercise 5: File Operations
Write a script that copies a file from one location to another. Both locations should be passed as arguments
```bash
#!/bin/bash #-xv
if [[ -d "$1" && -x "$1" ]] && [[ -d "$2" && -x "$2" ]];
then
	cp -fR "$1"/* "$2"/
  	echo "Copied"
else
  echo "Can't copy"
fi
```
### Exercise 6: String Manipulation
Build a script that takes a user's input as a sentence and then reverses the sentence word by word (e.g., "Hello World" becomes "World Hello").
```bash
read -rp "Enter a sentence: " TEXT_INPUT

if [ -z "${TEXT_INPUT}" ]; then
    echo "Empty input. Bye bye..."
    exit 1
fi

list=($TEXT_INPUT)
for i in `seq $((${#list[@]} - 1)) -1 0`; do
    echo "${list[$i]}"
done | xargs

```
### Exercise 7: Command Line Arguments
Develop a script that accepts a filename as a command line argument and prints the number of lines in that file.
```bash
read -rp "Enter a file name: " FILE_NAME

if [ ! -f "$FILE_NAME" ]; then
    echo "The file does not exist. Bye..."
    exit 1
fi

count=0
while IFS= read -r list || [[ -n $list ]]; do
	let count+=1
done < "$FILE_NAME"

echo "$count"
```
### Exercise 8: Arrays
Write a script that uses an array to store a list of fruits. Loop through the array and print each fruit on a separate line.
```bash
fruits=("Apple" "Banana" "Orange" "Pineapple")

for key in "${!fruits[@]}"
do
  echo "Key for fruits array is: $key"
done

for value in "${fruits[@]}"
do
  echo "Value for fruits array is: $value"
done

for key in "${!fruits[@]}"
do
  echo "Key is '$key'  => Value is '${fruits[$key]}'"
done
```
### Exercise 9: Error Handling
Develop a script that attempts to read a file and handles errors gracefully. If the file exists, it should print its contents; if not, it should display an error message.
```bash
read -rp "Enter a file name: " FILE_NAME

if [ ! -f "$FILE_NAME" ];
then
    echo "Sorry, the file does not exist."
else
	cat "$FILE_NAME"
	echo
fi
```

### Systemd service

Write script which watching directory "~/watch". If it sees that there appeared a new file, it prints files content and rename it to *.back
Write SystemD service for this script and make it running
```bash
cd ~
mkdir watch

sudo su
touch /var/log/akyna_file_monitor_user.log
chown akyna:akyna /var/log/akyna_file_monitor_user.log

cd /usr/local/bin/
vi akyna_file_monitor.sh
```
```bash
#!/bin/bash

EXT=back
DIR=~/watch/*

echo "${DIR%\/*}"
if [[ ! -d ${DIR%\/*} ]]; then
	echo "The directory does not exist"
	exit 1
fi

for i in $DIR; do
    if [ "${i}" == "${i%.${EXT}}" ];
	then
		[ -f "$i" ] || continue
		echo "File: $i" >> /var/log/akyna_file_monitor_user.log
		cat "$i" >> /var/log/akyna_file_monitor_user.log
		echo "--------" >> /var/log/akyna_file_monitor_user.log
		mv "$i" "$i".back
    fi
done
```
```bash
chmod +x akyna_file_monitor.sh
cd /etc/systemd/system
vi akyna_file_monitor.service
```
```bash
[Unit]
Description=Monitor '~/watch' folder every 5 seconds

[Service]
User=akyna
ExecStart=/usr/local/bin/akyna_file_monitor.sh

[Install]
WantedBy=multi-user.target
```
```bash
vi akyna_file_monitor.timer
```
```bash
[Unit]
Description=Monitor '~/watch' folder every 5 seconds timer

[Timer]
OnCalendar=*:*:0/5
AccuracySec=1s

[Install]
WantedBy=timers.target
```
```bash
systemctl daemon-reload
systemctl enable --now akyna_file_monitor.timer
systemctl status akyna_file_monitor.timer akyna_file_monitor.service
```
```bash
akyna@amb-server:/etc/systemd/system$ systemctl status akyna_file_monitor.timer akyna_file_monitor.service
● akyna_file_monitor.timer - Monitor '~/watch' folder every 5 seconds timer
     Loaded: loaded (/etc/systemd/system/akyna_file_monitor.timer; enabled; preset: enabled)
     Active: active (waiting) since Fri 2024-06-28 18:17:17 UTC; 1h 51min left
    Trigger: Fri 2024-06-28 16:25:30 UTC; 1s left
   Triggers: ● akyna_file_monitor.service

Jun 28 18:17:17 amb-server systemd[1]: Started akyna_file_monitor.timer - Monitor '~/watch' folder every 5 seconds timer.

○ akyna_file_monitor.service - Monitor '~/watch' folder every 5 seconds
     Loaded: loaded (/etc/systemd/system/akyna_file_monitor.service; disabled; preset: enabled)
     Active: inactive (dead) since Fri 2024-06-28 16:25:25 UTC; 2s ago
   Duration: 3ms
TriggeredBy: ● akyna_file_monitor.timer
    Process: 1638 ExecStart=/usr/local/bin/akyna_file_monitor.sh (code=exited, status=0/SUCCESS)
   Main PID: 1638 (code=exited, status=0/SUCCESS)
        CPU: 3ms

Jun 28 16:25:25 amb-server systemd[1]: Started akyna_file_monitor.service - Monitor '~/watch' folder every 5 seconds.
Jun 28 16:25:25 amb-server akyna_file_monitor.sh[1638]: /home/akyna/watch
Jun 28 16:25:25 amb-server systemd[1]: akyna_file_monitor.service: Deactivated successfully.
akyna@amb-server:/etc/systemd/system$
```
```bash
sudo su akyna
cd ~/watch
vi file_1.txt
```
```bash
SOME NEW INPUT
```
```bash
akyna@amb-server:~/watch$ ls
file_1.txt
akyna@amb-server:~/watch$
```
```bash
akyna@amb-server:~/watch$ ls
file_1.txt.back
akyna@amb-server:~/watch$
```
```bash
akyna@amb-server:~/watch$ tail /var/log/akyna_file_monitor_user.log
File: /home/akyna/watch/file_1.txt
SOME NEW INPUT
--------
akyna@amb-server:~/watch$
```
