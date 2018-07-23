# gpdb-docker
Pivotal Greenplum Database Base Docker Image (5.9)

[![](https://images.microbadger.com/badges/version/pivotaldata/gpdb-base.svg)](https://microbadger.com/images/pivotaldata/gpdb-base "Get your own version badge on microbadger.com")


cd [docker working directory]

docker build -t [tag] .

# Running the Docker Image
docker run -i -p 5432:5432 [tag]

# Container Accounts
root/pivotal

gpadmin/pivotal

# Using psql in the Container
su - gpadmin

psql

# Using pgadmin outside the Container
Launch pgAdmin3

Create new connection using IP Address and Port # (5432)
