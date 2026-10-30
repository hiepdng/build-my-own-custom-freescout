## My Custom FreeScout Build

Download the repository:  
```
git clone git@github.com:hiepdng/build-my-own-custom-freescout.git
```

Build FreeScout image:  
```
docker build -t my-custom-freescout:latest .
```

Run FreeScout:  
```
docker compose up -d
```
Initial setup:
Go to http://localhost:8080/install and follow instructions.

Debuging:
```
# Goto Freescout app OS:
docker exec -it freescout_app bash

freescout$ 
```
