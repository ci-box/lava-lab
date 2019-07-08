# lava-lab
Simple Lava lab recipe to generate a basic Lava lab instance with a Qemu and Dragonboard-410c device

The instance is composed of docker containers, a lava-server (lava_server), lava-dispatcher (lava_worker0), squad, jenkins, and a file-server (fileserver).
- Jenkins instance automatically builds software and generate images to tests, then trigger testing
- The file-server store artifacts (e.g. images to test, test templates, etc...)
- The squad container is for Software Quality Dashboard, Jenkins trigger tests via squad
- The lava-server (master) schedules the test jobs, administers devices ands stores the results
- The lava-dispatcher (worker) deploys software (images) on connected devices, and processes the test jobs

<!-- language: lang-none -->
    -------------------------------------------------------------------- Network
           |                |               |              |           |
     -------------   --------------   ------------    ----------    -----------
    |             | |              | |            |  |          |  |           |
    | lava_server | | lava_worker0 | | fileserver |  |  squad   |  |  jenkins  |
    |             | |              | |            |  |          |  |           |
     -------------   --------------   ------------    ----------    -----------
                      |         |
                      |         |
                      |         |
          [qemu-device_1]      [dragonboard-410c_1]


## Prerequisite

- docker
- docker-compose

## Customize for your hardware (dragonboard-410c)

The qemu device is handled out of the box, but testing on real hardware like dragonboard-410c requests a bit of configuration.
Indeed, in order to allows Lava to communicate with your DUT and control its power, you need to edit the device definition: ./overlays/lava-server/etc/lava-server/dispatcher-config/devices/dragonboard-410c_1@lava_worker0.jinja2

1. Define the power commands (e.g. to control relays, pdu...)
2. Define the connection command (to get serial/debug link with the board)
3. Define the board fastboot serial number (to detect and flash board)

## Create and Start instance

    make

or if your user is not part of `docker` group:

    sudo make


## Play

If you run command locally you can then access the Lava web user interface at localhost:8080
Since this instance defines a Qemu device and Qemu health-check job, you will see the health
check job scheduled and executed, same applies for the dragonboard 410c.

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
