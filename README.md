##  Custom Build a FreeScout Docker Image

This FreeScout custom build docker image is based on:  
 • [FreeScout application](https://github.com/freescout-help-desk/freescout)  
 • [php:8.5.12-apache docker image](https://hub.docker.com/layers/library/php/8.5.12-apache/images/sha256-4922ed28b65e7a7e4d3b111b4ceb059a29acad9fc06f4bd2fbb13f56424ddeda)  
 • [mariadb:13.0.2 docker image](https://hub.docker.com/layers/library/mariadb/13.0.2/images/sha256-6d882f903b25c6517caf5d14422ebfc371f4c34ebb8fd3c64320a6dc43c9271d)  

<br>

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
Go to http://localhost:8080/
<br>

---

- **Debugging:**  
```
# Goto Freescout database OS:
docker exec -it freescout_db bash

# Goto Freescout app OS:
docker exec -it freescout_app bash

freescout$ 
```
<br>

- **Fresh Re-Installation**:  
  In case something wrong with FreeScout and you want a totally new installation, run the following commands:  
```
# Remove containers and images:
docker rm -f freescout-app freescout-db
docker rmi mariadb:13.0.2 my-custom-freescout:latest

# Create volume directory:
cd docker_custom_build_freescout
sudo rm -Rf freescout_data freescout_db_data
mkdir reescout_data freescout_db_data

# Run new FreeScout application:
cd docker_custom_build_freescout
docker build -t my-custom-freescout:latest .
docker compose up -d
```
