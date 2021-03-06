# Open Datacube 1.6.1

This image contans:

* datacube 1.6.1
* Python 3.6.7

## Prepare the OpenDataCube database 

Pull the datacube Docker Image from [Dockerhub](https://hub.docker.com/r/opendatacube/datacube-core) as depicted below.

```sh 
docker pull opendatacube/datacube-core:1.6.1
```

Create a directory to work on this project

```sh 
mkdir datacube_shared 
cd datacube_shared
```

Run the open datacube container

```sh 
docker run \
	-it \
	--name mycube \
	-e DATACUBE_CONFIG_PATH=/opt/custom-config.conf \
	-e DB_DATABASE=datacube  \
	-e DB_HOSTNAME=localhost \
	-e DB_USERNAME=cube  \
	-e DB_PASSWORD=cube  \
	-e DB_PORT=5432 \
	-v ${PWD}:/datacube_shared
	opendatacube/datacube-core:1.6.1 \
	bash
```

Create a **cube** user with password 'cube'.

```sh 
apt update
apt install sudo
adduser cubo
usermod -aG sudo cubo
su cubo

sudo apt install postgresql postgresql-contrib
```

Install postgres 

```sh 
sudo apt install postgresql postgresql-contrib
sudo service postgresql start
```

Get into the postgres console and update the password of the **postgres** user. Use 'postgres' as password. Then configure a **cube database user**. 

```sh 
sudo -u postgres psql postgres

postgres=# \password postgres
postgres=# create user cube with password 'cube';
postgres=# alter user cube createdb;
postgres=# alter user cube createrole;
postgres=# alter user cube superuser;
postgres=# \q
```

Create a **datacube** database

```sh 
createdb datacube
```

Initialize the datacube system (database tables creation). And check all is working properly.

```sh 
datacube -v system init

Initialising database...
2019-09-04 17:33:32,802 2356 datacube.drivers.postgres._core INFO Ensuring user roles.
2019-09-04 17:33:32,874 2356 datacube.drivers.postgres._core INFO Creating schema.
2019-09-04 17:33:32,874 2356 datacube.drivers.postgres._core INFO Creating tables.
2019-09-04 17:33:33,390 2356 datacube.drivers.postgres._core INFO Adding role grants.
2019-09-04 17:33:33,402 2356 datacube.index.index INFO Adding default metadata types.
Created.
Checking indexes/views.
2019-09-04 17:33:33,530 2356 datacube.drivers.postgres._api INFO Checking dynamic views/indexes. (rebuild views=True, indexes=False)
Done.
```


```sh 
datacube system check

Version:       1.6.1+0.gee3c3d81.dirty
Config files:  /opt/custom-config.conf
Host:          localhost:5432
Database:      datacube
User:          cube
Environment:   None
Index Driver:  default

Valid connection:	YES
``` 

Exit within the container 

```sh 
exit
```

Get into the container

```sh 
docker exec -it mycube bash
```

Stop container (first exit)

```sh 
docker stop mycube
```

Start container (if conainer is not running)

```sh 
docker start -ia mycube
```

Remove the container (first stop the container)

```sh 
docker rm mycube
```

# References

[Open Datacube Install](https://buildmedia.readthedocs.org/media/pdf/opendatacube/latest/opendatacube.pdf) 
