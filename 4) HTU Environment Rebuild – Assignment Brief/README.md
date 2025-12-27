



## Introduction

Hello Trainee,

We are contacting you following a critical incident that recently affected one of our major clients, HTU. Due to the sudden departure of several members of the former SysAdmins team, large portions of the infrastructure were left without proper documentation or maintenance. This resulted in a major outage for HTU a few days ago.

HTU has expressed strong dissatisfaction and indicated that any similar incident in the future may lead to the termination of their contract, posing a serious risk to our business relationship and overall reputation.

We urgently require your support to rebuild and stabilize HTU’s environment from the ground up. As they operate an Enterprise Multi-User Environment, the system must be reconstructed with proper security, user access control, storage integrity, and service reliability.

Because no documentation was left behind, you must perform a complete reinstallation and reconfiguration of their RHEL server from scratch.

---

# 1. Server Rebuild Task

Rebuild HTU’s Enterprise Multi-User Environment server using the following specifications:

- 4 vCPU 
- 4 GB RAM 
- 20 GB Disk 
- 40 GB Disk 
- Operating System: Red Hat Enterprise Linux (RHEL) 

---

# 2. OS Installation Requirements

After preparing the server hardware and confirming that it is ready for deployment, the next step is to install Red Hat Enterprise Linux using standard installation methods. In addition to the manual installation, you must also configure an automated installation workflow using Kickstart to support consistent and repeatable deployments across HTU’s environment.

To proceed, complete the RHEL installation using the specified settings, and then generate a Kickstart file that accurately reflects the configuration you applied during the setup.

## 2.1 Language & Localization

- Language: English (US) 
- Keyboard: English (US) 
- Timezone: Asia/Amman 

## 2.2 Disk & Partitioning

- Select the 20 GB disk 
- Use Automatic Partitioning 

## 2.3 User Configuration

- Disable direct root login 
- Create an administrative user:
    - Username: sysadmin 
    - Add to the wheel group 
    - Use a strong password

## 2.4 Software Selection

- Minimal Install 
- Leave all other settings as default

  

## 2.5 Automated Installation (Kickstart)

Prepare a Kickstart configuration that reflects all installation settings above.

Ensure:

- The file accurately replicates all installation parameters
- It fully automates the deployment workflow

Before applying advanced configurations, you must ensure that the server is reachable over the network and that remote administrators can connect to it. After completing the OS installation, configure and establish a secure remote session by connecting to the server via SSH.

> Note: All remaining tasks must be performed through SSH remote access rather than through the local VirtualBox console.

  

---

# 3. Initial System Setup (Post-Installation)

After reinstalling the operating system, the server is still in a raw, unconfigured state.

To prepare HTU’s environment for production use, you must install essential tools, apply updates, and ensure the system is properly registered for package usnig DNF.

## 3.1 Register the Server

- Register with Red Hat Subscription Management
- Enable access to official repositories and updates

  

## 3.2 Update the Entire System

- Update all packages to their latest versions

## 3.3 Install Essential Tools

|Package|Purpose|
|---|---|
|nano|Text editor for configuration files|
|VDO + kmod-kvdo|Storage optimization (compression & deduplication)|
|rsync|Secure directory migration|
|tuned|System performance optimization|
|httpd / nginx|Web server for hosting and delivering web content|
|net-tools (optional)|Legacy networking utilities|

---

# 4. Storage Configuration (40GB Disk)

During the outage, HTU’s departments lost access to their shared files because the previous storage design was neither structured nor properly managed. To avoid similar issues, you must rebuild the storage layout on Disk 2 by preparing its partitions correctly, managing its local storage resources, and applying a clean file-system structure for all departmental data. In addition, the new layout must implement a flexible logical volume structure and an expanded swap area, both configured in a way that ensures stable performance and full persistence across system reboots.

To implement this improved storage strategy, the following components must be placed on Disk 2 and configured according to HTU’s reliability and scalability requirements:

Disk 2 must host:

- `/home`.bak 
- `/company` 
- Additional swap 

## 4.1 Partitioning Requirements

- Use GPT 
- Create one large LVM partition 
- Use XFS for all filesystems 

## 4.2 /home (15GB LV)

- Must reside fully on Disk 2
- Create a 15GB LV using the optimized storage layer prepared earlier
- Migrate using rsync 
- Do not delete original `/home` → rename to `/home.bak` 

## 4.3 /company (10GB LV)

- Must reside fully on Disk 2
- Create a 10GB LV using the optimized storage layer prepared earlier 

## 4.4 Additional Swap LV

- Follow Red Hat RAM-based recommendations
- Do not modify the installation-created swap
- Ensure both swaps are active and persistent

## 4.5 Persistence

All mounts and swap configurations must be defined in `/etc/fstab`.

---

# 5. Departmental Directory Structure

HTU operates several departments, each requiring its own dedicated workspace for storing and managing internal files. To set this up, you must use the command-line interface to create the required directory structure and organize it according to departmental needs. Once the directories are in place, you must establish comprehensive access-control rules using advanced permission management, ensuring that members of each department can collaborate securely while preventing unauthorized access or modification.

  

To begin implementing this structure, create the following departmental directories:

```PlainText
/company/hr

/company/finance

/company/engineering

/company/management
```

## 5.1 Access Requirements

- Full isolation between departments
- Users in the same department may collaborate
- New files must inherit group ownership
- Users cannot delete files they don’t own

---

# 6. User Groups and Assignments

HTU’s departments depend on clearly defined user accounts and group memberships to control access to internal resources. To restore proper identity and permission management, you must create and manage the required users and assign each one to the appropriate department group using the command-line interface. As part of establishing comprehensive access control, each account must follow the organization’s password requirements and be placed under the correct administrative or departmental policy.

To establish proper departmental access control, you must create the following groups representing each HTU department:

- hr 
- finance 
- engineering 
- management 
- it 

---

## 6.1 User Accounts

All required user accounts must be created and assigned to the appropriate department group.

Use the password below for all accounts:

`Htu@123`

  

### User, Group, and Privilege Mapping

|Username|Department|Primary Group|Administrative Privileges|Password|
|---|---|---|---|---|
|sara|HR|hr|No|Htu@123|
|huda|HR|hr|No|Htu@123|
|ahmed|Finance|finance|No|Htu@123|
|rami|Finance|finance|No|Htu@123|
|omar|Engineering|engineering|No|Htu@123|
|ali|Engineering|engineering|No|Htu@123|
|manager|Management|management|No|Htu@123|
|admin1|IT|it|Yes|Htu@123|
|admin2|IT|it|Yes|Htu@123|

  

---

## 6.2 Home Directory Requirements

All users must be created following these rules:

- Each user must have a home directory located on Disk 2, within the new storage layout. 
- Each user must belong only to their department’s group. 
- Only the IT users (admin1 and admin2) must receive administrative privileges. 

---

# 7. Backup Mechanism Implementation

HTU requires a dependable backup routine that runs automatically without manual intervention. To accomplish this, you must first create an advanced Bash script that performs the required backup operations. After preparing the script, you will automate the backup task implemented in your bash script by scheduling it to run at the appropriate time using cron.

To begin implementing the automated backup process, create a script that performs the following actions:

## 7.1 Backup Script

Create a Bash script that:

- Archives all `/company` directories daily 
- Compresses them into a .tar file 
- Stores the archive in `/backup` 

## 7.2 Automation

Configure a cron job to run the backup daily at 11:59 AM.

---

# 8. Server Optimization with TuneD

HTU’s virtual server must remain responsive and stable as multiple departments rely on it for daily operations. To maintain consistent performance, you are required to apply effective performance-tuning techniques that optimize system behavior under different workloads. This involves installing the system’s tuning framework, enabling it at startup, and selecting the most appropriate optimization profile for a virtualized environment.

To begin optimizing the server, install TuneD and configure it as follows:

## 8.1 Install & Enable TuneD

- Enable auto-start at boot

## 8.2 Apply Profile

Activate:

- virtual-guest profile 

---

# 9. System Identity & Package Management

As HTU’s server is reintegrated into the environment, it must be configured with a reliable system identity and dependable package sources. This includes assigning the correct hostname, ensuring the system can resolve its own name even without external DNS services, and setting up stable repository configurations so that software packages and updates remain accessible at all times. By establishing proper hostname settings, local name resolution, and consistent repository definitions, the server becomes easier to manage, more predictable, and less prone to service interruptions.

To begin setting up the system’s identity and package sources, configure the hostname, name-resolution files, and YUM repositories as follows:

## 9.1 Hostname

Set hostname to:

```PlainText
htu-server.ceu.local
```

## 9.2 Local Hostname Resolution

Ensure the hostname resolves locally without DNS.

---

# 10. YUM Repository Configuration

Configure and enable:

### 10.1 BaseOS

```PlainText
http://content.example.com/rhel8.0/x86_64/dvd/BaseOS
```

### 10.2 AppStream

```PlainText
http://content.example.com/rhel8.0/x86_64/dvd/AppStream
```

---

# 11. Temporary HR Web Application Placeholder

HTU requires a temporary HR placeholder page to remain available until the final application is completed. To deploy this service correctly, you must configure and manage the web server by controlling its processes and system services using systemctl and related system tools, ensuring that the service can be started, stopped, and enabled at boot. In addition, you are required to configure system-wide SELinux settings so the server can safely access the custom web directory and operate on a non-standard port. You must also configure the necessary firewall rules to allow controlled external access to the service while maintaining the security standards HTU follows across its environment.

To begin deploying the temporary HR placeholder, prepare the web content and configure the service as follows:

## 11.1 Web Content

- Create:

```PlainText
/opt/hr_placeholder/
```

- Add a simple “Coming Soon” HTML page

## 11.2 Web Service

- Configure Apache/Nginx --> they are different web servers (choose one)
- Serve content from `/opt/hr_placeholder/` 
- Run on port 82 
- Enable as a systemd service
- Ensure the web service
    - Runs continuously in the background
    - Starts automatically after every reboot
    - Is enabled as a systemd-managed service

## 11.3 SELinux

- Keep Enforcing mode 
- Apply correct SELinux context
- Allow web service to use port 82 

## 11.4 Firewall

- Permanently allow port 82 

---

# 12. SSH Service Hardening

HTU enforces strict security standards for all remote-access services, especially after the recent outage. Although there are many advanced methods for securing enterprise network services, HTU requires a baseline hardening approach that focuses specifically on protecting SSH access. As part of this requirement, you must secure the server’s SSH service by applying strong authentication methods, restricting remote logins, and enforcing policies that ensure only authorized administrative users can access the system.

To begin securing the SSH service, implement the following requirements:

## 12.1 SSH Key Authentication

- Generate SSH key pair for sysadmin 
- Install public key
- Validate key-based login

## 12.2 Disable Password Login for sysadmin

- sysadmin must authenticate only using keys 

## 12.3 Disable Password Authentication System-Wide

- Disable password logins for all users 

## 12.4 Restrict SSH Access

- Only authorized administrative users may access SSH remotely
- Deny SSH access to non-administrative accounts