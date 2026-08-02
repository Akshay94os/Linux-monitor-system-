#!/bin/bash
# Linux System Monitor & Management Tool

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/system.log"
mkdir -p "$LOG_DIR"

log(){ echo "$(date '+%F %T') - $1" >> "$LOG_FILE"; }

system_info(){
echo "Hostname : $(hostname)"
echo "Kernel   : $(uname -r)"
echo "OS       : $(uname -o)"
echo "Uptime   : $(uptime -p)"
log "Viewed system info"
}

cpu_usage(){ top -bn1 | grep "Cpu(s)"; log "Viewed CPU"; }
memory_usage(){ free -h; log "Viewed memory"; }
disk_usage(){ df -h; log "Viewed disk"; }
users_logged(){ who; log "Viewed users"; }
top_processes(){ ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -6; log "Viewed processes"; }

service_check(){
read -p "Enter service name: " s
systemctl status "$s" --no-pager
log "Checked service $s"
}

backup_dir(){
read -p "Directory to backup: " d
if [ -d "$d" ]; then
f="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$f" "$d"
echo "Backup created: $f"
log "Backup $d"
else
echo "Directory not found."
fi
}

view_log(){ cat "$LOG_FILE"; }

while true
do
echo "===== Linux System Monitor ====="
echo "1.System Info"
echo "2.CPU Usage"
echo "3.Memory Usage"
echo "4.Disk Usage"
echo "5.Logged-in Users"
echo "6.Top Processes"
echo "7.Check Service"
echo "8.Backup Directory"
echo "9.View Log"
echo "0.Exit"
read -p "Choice: " ch
case $ch in
1) system_info;;
2) cpu_usage;;
3) memory_usage;;
4) disk_usage;;
5) users_logged;;
6) top_processes;;
7) service_check;;
8) backup_dir;;
9) view_log;;
0) echo "Goodbye"; exit 0;;
*) echo "Invalid choice";;
esac
echo
done
