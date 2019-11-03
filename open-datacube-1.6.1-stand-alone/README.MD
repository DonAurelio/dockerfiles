# Open Datacube 1.6.1

This image contans:

* datacube 1.6.1
* Python 3.6.5

## Prepare the OpenDataCube database 

Create a directory to work with OpenDatacube related projects

```sh 
mkdir datacube_projects && cd  datacube_projects
```

Run the open datacube container

```sh 
docker run -it --name datacube -v ${PWD}:/home/datacube/shared donaurelio/open-datacube:1.6.1-stand-alone bash
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

Check the datacube is working properly

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

Start container 

```sh 
docker start -ia datacube
```

Remove the container (first stop the container)

```sh 
docker rm datacube
```

# References

[Open Datacube Install](https://buildmedia.readthedocs.org/media/pdf/opendatacube/latest/opendatacube.pdf) 
