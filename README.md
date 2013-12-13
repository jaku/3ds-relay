3ds-relay
=========

3ds-relay. This will create a wireless access point and spoof and cycle the MAC address to known Nintendo 3DS Relay Stations. 

Currently does not work on OS X 10.9. Work in progress.

Instructions
=========

Make sure you create a file called "macs" in the same directory or download the copy from the repository.
You must setup Internet Sharing within System Preferences at least once before running this. Make sure your SSID is set to "attwifi" as well. 
Once that is done, ensure that you make "3ds-relay.sh" exectuable by running "chmod +x 3ds-relay.sh" while in Terminal.
Now, run the script with "sudo ./3ds-relay.sh". It will ask you 3 questions the first time you run it.
If you enter the wrong settings, you can run "sudo rm ~/.3ds-relay" to be asked them again.

The script should now be running, and your AP should start and stop with a new MAC address every 5 minutes!

Contact me if you have any questions @jaku or /u/jakuu.

The script will now ask a 3rd question, "Enter row number for Internet Sharing (default: 8):" this should be the row number that you find "Internet Sharing" on, under Preferences - Sharing. On the image below it is row number 8, while File Sharing is row number 2, your screen might have a different order.
