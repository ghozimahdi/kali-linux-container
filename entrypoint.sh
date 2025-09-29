#!/bin/bash

echo "🐧 Kali Linux Container Started"
echo "📁 Shared folder: /shared"
echo "🔧 Web Tools: sublist3r, amass, gobuster, nikto, wafw00f, finalrecon, waybackurls"
echo "📱 Mobile Tools: adb, fastboot"
echo "💡 Use './kali.sh shell' to access terminal"
echo "📲 ADB ready - connect to host emulator with 'adb connect <emulator_ip>'"

# Keep container running
exec tail -f /dev/null