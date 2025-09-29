#!/bin/bash

echo "🐧 Kali Linux Container Started"
echo "📁 Shared folder: /shared"
echo "🔧 Tools available: sublist3r, amass, gobuster, nikto, wafw00f, finalrecon, waybackurls"
echo "💡 Use './kali.sh shell' to access terminal"

# Keep container running
exec tail -f /dev/null