# <div align="center">$${\color{purple}Custom \space Build \space a  \space FreeScout \space Docker \space Image}$$
<br>

This GitHub repository provides the source code to build FreeScout application - a self-hosted open-source shared inboxes, help desk, ticketing system. The source code is used to build FreeScout application on docker image. This code is tested on Ubuntu 26.04.1 LTS and expected to work on Linux based Operating Systems.  

This FreeScout custom build docker image is based on:  
 • [FreeScout application](https://github.com/freescout-help-desk/freescout)  
 • [php:8.5.12-apache docker image](https://hub.docker.com/layers/library/php/8.5.12-apache/images/sha256-4922ed28b65e7a7e4d3b111b4ceb059a29acad9fc06f4bd2fbb13f56424ddeda)  
 • [mariadb:13.0.2 docker image](https://hub.docker.com/layers/library/mariadb/13.0.2/images/sha256-6d882f903b25c6517caf5d14422ebfc371f4c34ebb8fd3c64320a6dc43c9271d)  
<br>

Files provided:  
**docker_custom_build_freescout/**  
├── **development/**  
│   └── readme.txt  
├── docker-compose.yml  
├── Dockerfile  
├── **freescout_data/**  
├── **freescout_db_data/**  
├── README.md  
└── setup  

Where:  
 - The **setup** file is the entrypoint script. It is also used to set FreeScout admin username and password to login the FreeScout web page.  
 - The **Dockerfile** file is used to build the FreeScout docker images.  
 - The **docker-compose.yml** file is used to run The FreeScout app and FreeScout database containers. It also holds all parameter values for the FreeScout's .env file, and hold usernames and password of Mariadb database accounts.  
  
<br>

## Set up to run FreeScout on Docker container


- **Download the repository:**  
```
git clone git@github.com:hiepdng/docker_custom_build_freescout.git
```
<br>

- **Build FreeScout images:**  
```
cd docker_custom_build_freescout
docker build -t my-custom-freescout:latest .
```
<br>

- **Run FreeScout containers:**  
```
docker compose up -d
```
<br>

- **Login to FreeScout webpage:**  
  - Go to http://localhost:8080/ to login the FreeScout app.  
  - The default URL to login the FreeScout web page is http://localhost:8080/. Edit `APP_URL` parameter from the `docker-compose.yml` to change to your own URL.  
  - The default admin username and password to login the FreeScout web page is `admin@example.com` and `admin_passwd`. Edit the `setup` file to set your own default username and password.  
  - Mailbox Settings:
    Once you login to your FreeScout app. You can setup `Mailboxex`, `Sending Emails` option and `Fetching Emails` option. The below is the settings that work for me.  
    Note: For gmail, you can't simply add your gmail password at the slot. It only accepts a gmail app password. An app password is a 16-digit passcode that lets third-party apps or non-Google devices access your Google Account when they do not support standard "Sign in with Google" verification. Go to [Google App Passwords page](https://support.google.com/mail/answer/185833?hl=en) to create your gmail app password.
    
    - **Manage** -> **Mailboxes** -> **New Mailbox**  
      - **Edit Mailbox**  
        • Mailbox Name: <Your Mailbox Name>  
        • Email Address: <yourusername@gmail.com>  
        • From Name: Mailbox Name  
        • Status After Replying: Pending  
        • Default Assignee: Person Replying (if Unassigned)  
        Save  
      - **Connection Settings**  
        **Sending Emails**  
          • SMTP  
          • SMTP Server: smtp.gmail.com  
          • Port: 587  
          • Username: <yourusername@gmail.com>  
          • Password: xxx (gmail app password)  
          • Encryption: TLS (+StartTLS)  
          • Send Test To:  <yourusername@gmail.com>  
          Save Settings  
        **Fetching Emails**  
          • Fetch From:  <yourusername@gmail.com>  
          • Protocol: POP3  
          • Server: pop.gmail.com  
          • Port:  995  
          • Username: <yourusername@gmail.com>  
          • Password: xxx (gmail app password)  
          • Encryption: TLS (+StartTLS)  
          Save Settings
        
<br>

---

**Setup Cronjob for FreeScout's Update and Scheduled Tasks:**  
Create cronjobs on the host system to evaluate and execute any FreeScout's scheduled tasks (such as fetching emails, sending emails, etc.) and running FreeScout update.  

- Create a /etc/cron.d/freescout_cronjob file:
```bash
* * * * * docker exec freescout-app php artisan schedule:run >> /dev/null 2>&1
0 0 * * 0 docker exec freescout-app bash -c "tools/update.sh --yes >> storage/logs/update.log"
```
- Restart system cron service:
```
$ sudo systemctl restart cron.service
```

 
<br>

---

**FreeScout Data Backup and Restore:**  
  FreeScout saves its data in two locations:  
  - The `storage/` directory in the freescout_data container (is also a `freescout_data/` volume mount directory in your host OS.) It keeps all email attachments, cache files and temp files.   You can just simply backup this entire directory.  
  - The Mariadb database. It keeps emails, tickets, user profiles, and application settings.
    - To backup the entire database:
    ```
    docker exec -i freescout-db mariadb-dump -u root -p<your_root_password> --all-databases \
          | gzip > mariadb_backup_$(date +%F).sql.gz
    ```

    - To restore your database backup:  
    ```
    gunzip < mariadb_backup_xxxx.sql.gz | docker exec -i freescout-db mariadb -u root -p<your_root_password>
    ```
     Where: <your_root_password> is specified in the docker-compose.yml file
<br>

---

**Debugging:**  
```
# Goto Freescout database OS:
docker exec -it freescout-db bash

# Goto Freescout app OS:
docker exec -it freescout-app bash

# Some useful commands
freescout# php artisan freescout:check-requirements      <-check requirements
freescout# php artisan queue:failed                      <-list all of the failed queue jobs
freescout# php artisan freescout:clear-cache             <-clean cache
freescout# php artisan freescout:fetch-emails            <-fetch emails
freescout# php artisan  freescout:fetch-monitor          <-Check emails fetching
freescout# php artisan freescout:create-user             <-create a new user
freescout# php artisan freescout:logout-users            <-logout all users
```
◦ If the `.env` file lacks of `APP_KEY value`, run below commands to create a new one:  
  ```
  $ docker exec -it freescout-app bash
  container# php artisan key:generate
  container# php artisan freescout:clear-cache
  ```
<br>

---

**Fresh Installation**:  
  In case something wrong with FreeScout and you want a totally new installation, run the following commands:  
  Note: all data in database directory will be deleted.  
```
# Remove containers and images:
docker rm -f freescout-app freescout-db
docker rmi mariadb:13.0.2 my-custom-freescout:latest

# Create volume directories:
cd docker_custom_build_freescout
sudo rm -Rf freescout_data freescout_db_data
mkdir reescout_data freescout_db_data

# Run new FreeScout application:
cd docker_custom_build_freescout
docker build -t my-custom-freescout:latest .
docker compose up -d
```
