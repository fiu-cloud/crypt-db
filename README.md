# crypt-db
Distributed privacy preserving compute





### Manual build commands
```
docker build -t fiu-cloud/crypt-db:latest .
docker kill crypt-db
docker rm crypt-db
docker run --name crypt-db  -e POSTGRES_PASSWORD=mysecret -p 5432:5432 -d fiu-cloud/crypt-db
docker exec -i -t crypt-db /bin/bash
``` 

### Useful commands
```
Find version
apt-cache policy [package]
python3 -m pip show [package]

Install Version
apt-get install [package]=[version]
python3 -m pip install [package]==[version]

Python Modules installed
help("modules")


```

