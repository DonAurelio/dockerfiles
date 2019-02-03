The LD_LIBRARY_PATH placed at line 37 in the Dockerfile is to enable OpenMPI shared libraries during the 
gromacs compilation process.

```sh
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/" \
```

We need to check if this line can be placed in the first RUN corresponding to the MPI install process.