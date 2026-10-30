## My Custom FreeScout Build

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
