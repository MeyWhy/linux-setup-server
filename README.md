## Linux Server Setup 
This project is intended for the roadmap.sh lab, i decided to make it into a bash script file to run it once and set up the server in one go.

## Requirements
- User Setup
- SSH Configuration
- Firewall Configuration
- System Updates
- Basic Hardening
- Server Configuration
- Service Management
- Log Inspection
- Verification

## Steps for fullfilling the requirements
After root SSH into a fresh linux Ubuntu, update the system, add a non root sudo user, config the ssh keys (from the local computer), test it, disable password auth, config the firewall,  automate secu updates, install fail2ban, config hostnames, config timezones, learn systemctl, check the logs, explore the /var/log, verify all the security checklist. And done 

## Usage

Make the script executable:

```bash
chmod +x setup-server.sh
```

Run the script as root:

```bash
sudo ./setup-server.sh
```


## Notes

Some steps, such as generating SSH keys on your local machine and copying the public key to the server, must be completed manually before disabling password authentication. (might add more steps later)

This project is intended as a learning exercise in Linux system administration and server security, and serves as a foundation for deploying production-ready applications.