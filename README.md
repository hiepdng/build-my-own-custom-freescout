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

- **Build the FreeScout image:**  
```
cd docker_custom_build_freescou
docker build -t my-custom-freescout:latest .
```

- **Run the FreeScout container:**  
```
docker compose up -d
```

- **Login to FreeScout webpage:**  
Go to http://localhost:8080/

- **Debugging:**  
```
# Goto Freescout database OS:
docker exec -it freescout_db bash

# Goto Freescout app OS:
docker exec -it freescout_app bash

freescout$ 
```
