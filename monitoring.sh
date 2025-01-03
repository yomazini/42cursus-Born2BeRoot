#!/bin/bash
while true; do
        sleep 600
wall    "
        #Architecture: $(uname -a)
        #CPU physical: $(cat /proc/cpuinfo | grep "physical id" | wc -l)
        #vCPU : $(cat /proc/cpuinfo | grep processor | wc -l)
        #Memory Usage: $(free --mega | awk 'NR==2{printf("%s/%sMB (%.2f%%)", $3, $2, ($3/$2) * 100)}')
        #Disk Usage: $(df -h --total | grep  "^total" | awk '{printf "%.f/%.fGb (%s)", $3, $2, $5}')
        #CPU load: $(mpstat |awk 'NR==4{print 100 - $13}')%
        #Last boot: $(who -b | awk '{printf("%s %s", $3, $4)}')
        #LVM use: $(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
        #Connections TCP : $(ss -ta | grep ESTAB | wc -l) ESTABLISHED
        #User log: $(users | wc -w)
        #Network: IP $(hostname -I) ($(ip link | grep "link/ether" | awk '{print $2}'))
        #Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd
        "
done
