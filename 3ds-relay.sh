#!/bin/bash
#3ds-relay.sh version 2.0
#Created by @jaku - /u/jakuu

#Check to see if config file is created, if not prompt user for information
if [ ! -f ~/.3ds-relay ]
  then
	echo -ne "Enter your Wireless interface (ex: en0, en1): "
	read wireless
	echo -ne "Enter your Wired interface (ex: en0, en1): "
	read wired
	echo -ne "Enter row number for Internet Sharing (default: 8): "
	read internetsharing
	echo "Wireless = $wireless" > ~/.3ds-relay
	echo "Wired = $wired" >> ~/.3ds-relay
	echo "WirelessMAC = `ifconfig $wireless | grep ether | awk {'print $2'}`" >> ~/.3ds-relay
        echo "WiredMAC = `ifconfig $wired | grep ether | awk {'print $2'}`" >> ~/.3ds-relay
	echo "INTERNETSHARING = $internetsharing" >> ~/.3ds-relay
fi

INETSERVICE=$(pgrep InternetSharing) #Check to make sure InternetSharing is not running
#If InternetSharing is running, script will die.
[ -n "$INETSERVICE" ] && echo "InternetSharing is enabled, please manually disable and re-run 3ds-relay.sh" && exit

#This will read the config file located at ~/.3ds-relay
shopt -s extglob
while IFS='= ' read lhs rhs
do
    if [[ $line != *( )#* ]]
    then
        declare $lhs=$rhs
    fi
done < ~/.3ds-relay

[ -z "$INTERNETSHARING" ] && echo "New script, please run "sudo rm -rf ~/.3ds-relay" and re-reun 3ds-relay.sh" && exit

#Creating an applescript to enable/disable InternetSharing since CommandLine isn't always working.
echo '
tell application "System Preferences"
	activate
end tell

tell application "System Events"
	tell process "System Preferences"
		click menu item "Sharing" of menu "View" of menu bar 1
		delay 2
		tell window "Sharing"
			click checkbox 1 of row '$INTERNETSHARING' of table 1 of scroll area 1 of group 1
			delay 1
			if (exists sheet 1) then
				if (exists button "Turn AirPort On" of sheet 1) then
					click button "Turn AirPort On" of sheet 1
				end if
				click button "Start" of sheet 1
			end if
		end tell
	end tell
end tell
tell application "System Preferences"
	quit
end tell
' > /tmp/internetsharing.scpt

for i in `cat macs`; do
        ifconfig $Wireless ether $i
	osascript /tmp/internetsharing.scpt
	echo "Now spoofing: $i"
	sleep 300 #sleeps for 5 minutes
	osascript /tmp/internetsharing.scpt
	echo "Completed!"
done

#reset mac address to original
ifconfig $Wireless ether $WirelessMAC
