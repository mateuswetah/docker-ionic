**Ionic repository with development enviroment for Android builds.** 
*Status: experimental.*

To run this:
```
git clone https://github.com/mateuswetah/docker-ionic.git
cd docker-ionic
docker build -t ionic-image .
docker run -td --name ionic -h ionic -p 8100:8100 -p 35729:35729 --privileged -v /dev/bus/usb:/dev/bus/usb -v /<PATH_TO_YOUR_WORKING_DIR>/:/home/ -e HOST_USER_NAME=$USER -e HOST_USER_ID=$UID -e HOST_GROUP_NAME=$(id -g -n $USER || echo $USER) -e HOST_GROUP_ID=$(id -g $USER) ionic-image /bin/bash
docker exec -it ionic /bin/bash
```
Notice that the exposed ports (both server and usb paths) may change according to your local machine.

Inside docker, don't forget to change to your user in case you want to edit files from an editor in Host:

```
su <YOUR_USER_NAME>
cd <YOUR_USER_FOLDER>

```

Once you're inside your docker container and folder, you can follow usual workflow to an Ionic project:
```
git clone *some_ionic_repository* OR ionic start myApp sidemenu
cd myApp
npm install
ionic serve OR ionic cordova run Android.
```

If you plan to run `ionic serve`, remember to have your ports free.
If you plan to run `ionic cordova run android`, make sure to:
 - Have your phone plugged and with proper USB connection mode (PTP, sometimes MTP).
 - In case you have adb on your local machine, run `adb kill-server` there, then `adb devices` in your docker.

Edit Dockerfile variables in case you need to work with different Ionic, Cordova or NPM versions.

This repository doesn't support any Android Emulator yet. Credits to [this repository](https://hub.docker.com/r/agileek/ionic-framework/), which helped me build the Dockerfile.
