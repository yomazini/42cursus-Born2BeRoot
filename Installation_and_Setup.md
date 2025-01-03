
# 🛠️ Installation and Setup Guide: Born2BeRoot  

This guide will help you install and configure your **Born2BeRoot** virtual machine. Follow the steps carefully and ensure you understand each point to ace your project evaluation.

---

## 🚀 VirtualBox 101  

1. **Create a New Virtual Machine**:  
   - **Name**: Descriptive name of the virtual machine (e.g., `Born2BeRoot`).  
   - **Machine Folder**: The destination folder for the virtual machine image. *(Note: Do not forget to choose the GoInFree path.)*  
   - **Type**: Linux  
   - **Version**: Debian (64-bit)  
   - **Memory Size**: Allocate appropriate RAM "30.8G" for Bonus.  
   - **Hard Disk**:  
     - Select "Create a virtual hard disk now."  

2. **Hard Disk Configuration**:  
   - **File Type**: VDI (VirtualBox Disk Image).  
   - **Storage**: Dynamically allocated (the disk grows as it is used).  
   - **Size**: Set the virtual hard disk size.  

3. **Attach the ISO File**:  
   - Go to `Settings > Storage`.  
   - Under **Controller: IDE**, select **Empty**, then choose the ISO file of the OS in **Optical Drive > Attributes**.  

4. **Start the Virtual Machine**:  
   - Boot the virtual machine.  
   - You can scale the screen from `View > Virtual Screen`.  
   - Press the Windows button to move the mouse between the virtual machine and your desktop.  

---

## 📥 Installing the Operating System  
1. **Choose Language, Time Zone, and Keyboard Layout**:  

2. **Basic Configuration**:  
   - **Hostname**: Set this to `login42` (replace `login` with your Intra username).  
   - **Domain Name**: None "simply type {Enter}".  
   - **Root Password**: Create a strong password Respecting the Policy.  
   - **User Account**:  
     - Full Name: `login42`  
     - Username: `login42`.  
     - Password: Create a secure password for the new user.  


---

## 🗄️ Partition Disks  

1. **Partition Setup**:  
   - Choose **Manual**.  

2. **Create Partitions**:  
   - **Boot Partition (`sda1`)**:  
     - Select FREE SPACE.  
     - Create a new partition.  
     - Size: `500 MiB` "Not Mb".  
     - Type: Primary.  
     - Location: Beginning.  
     - Mount Point: `/boot`.  
     - Done setting up the partition.  

   - **Encrypted Partition (`sda5`)**:  
     - Select FREE SPACE.  
     - Create a new partition.  
     - Size: Use the remaining space.  
     - Type: Logical.  
     - Do not mount this partition yet.  
     - Done setting up the partition.  

3. **Write Changes**: Select "Write the changes to disk and configure encrypted volumes."  

---

## 🔒 Encryption and Logical Volume Manager (LVM)  

1. **Configure Encrypted Volumes**:  
   - Devices to encrypt: `sda5`.  
   - Erase data: Select **Yes**.  
   - Set the encryption passphrase: `Born2beRoot`.  

2. **Configure LVM**:  
   - Write changes to disk and configure LVM.  
   - Create Volume Group:  
     - Name: `LVMGroup`.  
     - Device: `/dev/mapper/sda5_crypt`.  
   - Create Logical Volumes:  
     ```plaintext
     Logical Volume Name  | Size  
     ---------------------|------  
     root                 | 10GiB  
     swap                 | 2.3GiB  
     home                 | 5GiB  
     var                  | 3GiB  
     var-log              | 4GiB  
     srv                  | 3GiB  
     tmp                  | 3GiB  
     ```  

3. **Editing Partitions**:  
   - Assign the following mount points:  
     - `/root`: root partition.  
     - `/home`: home partition.  
     - `/srv`: srv partition.  
     - `/var`: var partition.  
     - `/var/log`: var-log partition.  
     - `swap`: swap partition.  
     - `/tmp`: tmp partition.  

4. **Finalize**: Finish partitioning and write changes to disk.  

---

## ⚙️ Final Installation Steps  

1. **Skip Extra Installation Media**: Select **No**.  
2. **Choose Software to Install**: Remove all options.  
3. **Install GRUB Bootloader**: Yes. 
4. **Complete Installation**: Reboot the machine.  

---

## 🔐 Sudo Configuration  

1. **Switch to Root**:  
   ```bash
   su root  
   ```  

2. **Install Sudo**:  
   ```bash
   apt install sudo  
   ```  

3. **Add User to Sudo Group**:  
   ```bash
   adduser <username> sudo  
   ```  

4. **Verify User Addition**:  
   ```bash
   getent group sudo  
   ```  

5. **Reboot** for changes to take effect.  

6. **Edit Sudo Configuration**:  
   ```bash
   sudo visudo  
   ```  
   Add the following:  
   ```plaintext
   Defaults        passwd_tries=3  
   Defaults        badpass_message="Wrong password. Try harder!"  
   Defaults        log_input, log_output  
   Defaults        logfile=/var/log/sudo/sudo.log  
   Defaults        requiretty  
   Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"  
   ```  
7. **Validate Sudo Configuration**:

	```bash
	visudo -c  
	sudo chmod 0440 /etc/sudoers.d/sudo_config  
	```
---

## 🔒 Strong Password Policy  

1. **Set Password Expiration**:  
   Edit the login definitions file:  
   ```bash
   sudo vim /etc/login.defs  
   ```  
   Update the following:  
   ```plaintext
   PASS_MAX_DAYS 30  
   PASS_MIN_DAYS 2  
   PASS_WARN_AGE 7  
   ```  

2. **Enforce Password Complexity**:  
   Install the required package:  
   ```bash
   sudo apt install libpam-pwquality  
   ```  

3. **Edit Password Configuration**:  
   Open the configuration file:  
   ```bash
   sudo vim /etc/security/pwquality.conf  
   ```  
   Add the following:  
   ```plaintext
   minlen=10  
   ucredit=-1  
   dcredit=-1  
   lcredit=-1  
   maxrepeat=3  
   usercheck=1  
   difok=7  
   enforce_for_root  
   ```  

4. **Change Password Expiration Settings for Users**:  
   ```bash
   chage -M 30 -m 2 -W 7 <username>  
   ```  

---
## 🔐 SSH Configuration  

1. **Install OpenSSH Server**:  
   ```bash
   apt install openssh-server  
   ```  

2. **Configure SSH**:  
   ```bash
   sudo vim /etc/ssh/sshd_config  
   ```  
   Update the following:  
   ```plaintext
   Port 4242  
   PermitRootLogin no  
   ```  

3. **Restart SSH**:  
   ```bash
   sudo service ssh restart  
   ```  

---

## 🔥 UFW Configuration  

1. **Install UFW**:  
   ```bash
   apt install ufw  
   ```  

2. **Enable UFW**:  
   ```bash
   sudo ufw enable  
   ```  

3. **Allow Port 4242**:  
   ```bash
   sudo ufw allow 4242  
   ```  

4. **Verify UFW Rules**:  
   ```bash
   sudo ufw status  
   ```  

---

## 📜 Automating Monitoring Script  

1. **Create Monitoring Script**: Save the following script as `monitoring.sh`:  
   ```bash
   #!/bin/bash
   while true; do
       wall "
       #Architecture: $(uname -a)
       #CPU physical: $(grep -c 'physical id' /proc/cpuinfo)
       #vCPU: $(grep -c processor /proc/cpuinfo)
       #Memory Usage: $(free -m | awk 'NR==2{printf "%d/%dMB (%.2f%%)", $3, $2, $3*100/$2}')
       #Disk Usage: $(df -h --total | grep total | awk '{printf "%s/%s (%s)", $3, $2, $5}')
       #CPU load: $(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", $2 + $4}')
       #Last boot: $(who -b | awk '{print $3, $4}')
       #LVM use: $(lsblk | grep lvm | wc -l)
       #Connections TCP: $(ss -t | grep ESTAB | wc -l) ESTABLISHED
       #User log: $(who | wc -l)
       #Network: IP $(hostname -I) ($(ip link | grep ether | awk '{print $2}'))
       #Sudo: $(grep COMMAND /var/log/sudo/sudo.log | wc -l) cmds
       "
       sleep 600
   done
   ```  

2. **Automate the Script with `@reboot`**:  
   Add the following to crontab:  
   ```bash
   @reboot /path/to/monitoring.sh &  
   ```  

---

Congratulations! You’ve successfully set up your Born2BeRoot virtual machine. By following the steps outlined in this guide, you have ensured that your environment is both secure and optimized for the project. You now have a robust system with encryption, LVM, sudo configuration, strong password policies, and SSH access in place. The monitoring script will help you stay on top of system performance, while UFW ensures your firewall is configured correctly.

With your Born2BeRoot virtual machine up and running, it's time to focus on the project itself. Explore, implement, and test your configurations while making sure to follow best practices.
you will forget most of these steps so try to get deep in theorical parts and lets the commands and others syntax things for google to be generate ur job is not to memorize but to fix, to invest ur time into know how things wokrd in this case servesrs and linux and if something related to syntax.

---

### Final Advice

As you go through the process of setting up and configuring your Born2BeRoot virtual machine, remember that the true value lies in **_understanding the underlying principles_** rather than memorizing commands or syntax. Focus on grasping how servers and Linux systems function, from partitioning and encryption to user management and security configurations. The specific commands and syntax will always be available for reference, but the **_key to success_** is in truly comprehending the concepts and being able to adapt and troubleshoot effectively. **_Invest your time in mastering the theory_**, as this will make you more capable and confident when facing real-world challenges. Don't hesitate to use Google for syntax and specific solutions—what matters most is knowing **_why_** things work the way they do. Stay curious and keep learning! 🚀

For more details and deeper insights, check out my ***[Additional_information.md](./Additional_information.md)*** —where you'll find more ways to dive deeper into the concepts and explore further into the rabbit hole 🐇. Follow the White Rabbit! --> ***[Additional_information.md](./Additional_information.md)*** 🌟.