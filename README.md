# lava-lab
Simple Lava lab recipe to generate a basic Lava lab instance with a Qemu and Dragonboard-410c device

The instance is composed of docker containers, a lava-server (lava_server), lava-dispatcher (lava_worker0) and a file-server (fileserver).
- The lava-server (master) shcedules the test jobs, administers devices ands stores the results
- The lava-dispatcher (worker) deploys software (images) on connected devices, and processes the test jobs
- The file-server store artifacts (e.g. images to test, test templates, etc...)

<!-- language: lang-none -->
    --------------------------------------------------- Network
           |                |               |
     -------------   --------------   ------------
    |             | |              | |            |
    | lava_server | | lava_worker0 | | fileserver |
    |             | |              | |            |
     -------------   --------------   ------------
                      |         |
                      |         |
                      |         |
          [qemu-device_1]      [dragonboard-410c_1]


## Prerequisite

- docker
- docker-compose

## Create and Start instance

    make

or if your user is not part of `docker` group:

    sudo make

## Play

If you run command locally you can then access the Lava web user interface at localhost:8080
Since this instance defines a Qemu device and Qemu health-check job, you will see the health check job scheduled and executed.

That's all! you can now submit your own jobs (https://validation.linaro.org/static/docs/v2/explain_first_job.html)

## Advanced

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

TODO
