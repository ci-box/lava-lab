# CI LOOP with LAVA
A simple example of CI loop using LAVA for testing DUT
The docker-compose recipe setup all the CI components.

The instance is composed of docker containers
- Jenkins which is the build automation component, build the software and schedule jobs
- Squad is the result dashboard, it aggregates test results for specific project/versions.
- The lava-server (master) schedules the test jobs, administers devices ands stores the results
- The lava-dispatcher (worker) deploys software (images) on connected devices, and processes the test jobs
- The file-server store artifacts (e.g. images to test, test templates, etc...)

<!-- language: lang-none -->
    ---------------------------------------------------------------------- Network
           |                |               |             |         |
     -------------   --------------   ------------   ---------   -------
    |             | |              | |            | |         | |       |
    | lava_server | | lava_worker0 | | fileserver | | Jenkins | | Squad |
    |             | |              | |            | |         | |       |
     -------------   --------------   ------------   --------    -------
                           |
                           |
                           |
                     [qemu-devices]


## Prerequisite

- docker
- docker-compose

## Init/Update repo

    git clone -b ci-loop --single-branch https://github.com/ci-box/lava-lab.git
    cd lava-lab
    git submodule update --init

## Create and Start instance

    make

or if your user is not part of `docker` group:

    sudo make

## Play

If you run command locally you can then access the components:
- Jenkins interface: http://localhost:8083 (login admin/password)
- Squad interface: http://localhost:8080
- Lava web user interface: http://localhost:8042 (login admin/password)

This instance is for demoing purpose:
- A jenkins job (linux) is scheduled every 5 minutes to 'build' linux 
- The jenkins job publishes the kernel binary to the 'fileserver'
- The jenkins job retrieves LAVA job templates and schedule testing on the new binary
- SQUAD receive the test job requests and forward them to LAVA
- SQUAD monitor tests results and report results in linux projects

### Makefile

Makefile is mainly a docker wrapper, following helpers are available:

    make run

Build and execute instance.

    make start

Build and launch instance (detached from terminal)

    make stop

Stop a previoulsy started instance.

    make clean

Stop and remove instance


### Customize instance

Everything takes place in docker-compose.yaml file
