# Crypt-DB
Distributed privacy preserving compute

Postgres UDF (using python / prl) to do floating point paillier encryption operations

# Start Postgres & Python
```
docker run --name crypt-db  -e POSTGRES_PASSWORD=mysecret -p 5432:5432 -d fiucloud/crypt-db
```

You can now connect PgpAdmin or similar to you localhost running paillier postgres (port 5432). Try the example below

# Using python directly in container
```
docker exec -i -t crypt-db /bin/bash
...
python3
```



### Example
```
select init(); --Initialise global private / public key pairs

DROP TABLE IF EXISTS mock_tbl;
DROP TABLE IF EXISTS encrypted_tbl;
DROP TABLE IF EXISTS summed_tbl;
DROP TABLE IF EXISTS product_tbl;
DROP TABLE IF EXISTS decrypted_tbl;
DROP TABLE IF EXISTS test_tbl;

CREATE TABLE mock_tbl AS
    SELECT
        (random()-0.5) * 1000000 as a,
        (random()-0.5) * 1000000 as b,
        (random()-0.5) * 1000000 as c
    FROM generate_series(1,1000);

CREATE TABLE encrypted_tbl AS
    SELECT
        encrypt(a) as a,
        encrypt(b) as b,
        c,
        a as raw_a,
        b as raw_b
    from mock_tbl;
    
CREATE TABLE summed_tbl AS
    SELECT
        addition(a,b) as summed,
        c,
        raw_a,
        raw_b
    from encrypted_tbl;
    
CREATE TABLE product_tbl AS
    SELECT
        multiplication(summed,c) as actual,
        raw_a as a,
        raw_b as b,
        c
	FROM
		summed_tbl; 

CREATE TABLE decrypted_tbl AS
    SELECT
        decrypt(actual) as actual,
        a,b,c
	FROM
		product_tbl; 

CREATE TABLE test_tbl AS
	SELECT MAX(ABS(actual - ((a+b)*c))) as max_error
	FROM decrypted_tbl;
	
select * from test_tbl;

```



### Manual build commands
This is not required if pulling iamge from DockerHub
```
docker build -t fiucloud/crypt-db:latest .
docker kill crypt-db
docker rm crypt-db
docker run --name crypt-db  -e POSTGRES_PASSWORD=mysecret -p 5432:5432 -d fiucloud/crypt-db
docker exec -i -t crypt-db /bin/bash #Log into container
``` 

### Other useful commands
```
#Find package version
apt-cache policy [package]
python3 -m pip show [package]

#Install package version
apt-get install [package]=[version]
python3 -m pip install [package]==[version]

#Python modules
help("modules")
import sys
sys.path

```

