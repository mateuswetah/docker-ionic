**Ionic repository with development enviroment for Android builds.** 
*Status: experimental.*

To run this:
```
docker pull mateuswetah/ionic-android
docker build .
docker run -td --name ionic -h ionic -p 8100:8100 -p 35729:35729 --privileged -v /dev/bus/usb:/dev/bus/usb -v /home/<PATH_TO_YOUR_WORKING_DIR>/:/root/<PATH_TO_DOCKER_WORKING_DIR> mateuswetah/ionic-android /bin/bash
docker exec -it ionic /bin/bash
```

Notice that the exposed ports (both server and usb paths) may change according to your local machine.

Once you're inside your docker container, you can follow usual workflow to an Ionic project:
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

This repository doesn't support any Android Emulator yet. Credits to [this repository](https://hub.docker.com/r/agileek/ionic-framework/), which helped me build the Dockerfile.
