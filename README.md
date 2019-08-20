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
                      |    |    |
                      |    |    |
                      |    |    |
          [qemu-device_1] [X15] [dragonboard-410c_1]

## Prerequisite

- docker
- docker-compose

## Download test images

Some OS images, used for health-check testing are not part of the git repo.
They need to be downloaded manually:

    ./populate-fileserver.sh

## Clone the project and submodules

    git clone -b elc-demo https://github.com/ci-box/lava-lab.git
    cd lava-lab
    git submodule update --init

## Customize for your hardware (dragonboard-410c)

The qemu device is handled out of the box, but testing on real hardware like dragonboard-410c requests a bit of configuration.
Indeed, in order to allows Lava to communicate with your DUT and control its power, you need to edit the device definition: ./overlays/lava-server/etc/lava-server/dispatcher-config/devices/dragonboard-410c_1@lava_worker0.jinja2

1. Define the power commands (e.g. to control relays, pdu...)
2. Define the connection command (to get serial/debug link with the board)
3. Define the board fastboot serial number (to detect and flash board)

dragonboard-410c needs to be correctly partitioned, with empty boot partition.

## Configure network

In elc-demo power is controlled via an ethernet power switch which has a static
IP address (192.168.0.18). You then need to configure the dedicated downstream
network interface (e.g. eth0) accordingly, either via UI interface or conf files.

One way to achieve this is adding the following into /etc/network/interfaces:

    auto eth0
    iface eth0 inet static
    address 192.168.0.1
    netmask 255.255.255.0
    network 192.168.0.0
    broadcast 192.168.0.255

(Note: replace eth0 with the name of used net interface)

Then restart networking

    systemctl restart networking

You should then be able to ping the ethernet power switch:

    ping 192.168.0.18

AND, you should still be able to ping the 'internet' via upstream net interface
(e.g. wifi):

    ping 8.8.8.8

## Create and Start instance

    make

or if your user is not part of `docker` group:

    sudo make


## Play

If you run command locally you can then access the Lava web user interface at localhost:8080
Since this instance defines a Qemu device and Qemu health-check job, you will see the health
check job scheduled and executed, same applies for the dragonboard 410c.

That's all!

You should know have access to the various interfaces:
lava: http://localhost:8080
squad: http://localhost:8081
fileserver: http://localhost:8082
jenkins: http://localhost:8085

- On start lava automatically executes health check jobs for the existing devices.
- Log into jenkins to execute pre-defined projects (like linux-qcomlt).
    - log-in (right top corner) with 'admin'/'password'
    - select a job (e.g. linux-qcomlt)
    - Click on 'Build Now' (left column)
- Connect to squad dashboard for test results.
- Connect to lava for tests/devices status

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

#### Adding a device

To create a device instance, add its dictionary to overlays/lava-server/etc/lava-server/dispatcher-config/devices/.
The naming convention, which is used to automatically create device is DEVICETYPE_INDEX@WORKER.jinja2, e.g. qemu_1@lava_worker0.jinja2.

https://validation.linaro.org/static/docs/v2/lava-scheduler-device-dictionary.html

#### Changing ports

The exposed network ports are defined in docker-compose.yaml (- ports).

#### Changing user/login

Most of ci-box instances allows to define an admin user via docker-compose.yaml.
Adding regular users need to be done via each component interface (WEB UI, command line, etc...).

#### Attach to a running container

It can be useful to execute a shell in a specific instance, for debugging, hacking...

    sudo docker exec -it CONTAINER_NAME bash

e.g.

    sudo docker exec -it lava-server bash
