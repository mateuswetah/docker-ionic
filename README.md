**Ionic repository with development environment for Android builds.** 

To run this:

```bash
$ git clone https://github.com/mateuswetah/docker-ionic.git
$ cd docker-ionic
$ docker build -t ionic-image .
```

Make sure you have internet working, relax and go watch a movie. I would suggest [this one](http://lotr.wikia.com/wiki/The_Lord_of_the_Rings_Extended_Edition).
Once it's done:

```bash
$ docker run -td --name ionic -h ionic -p 8100:8100 -p 35729:35729 --privileged -v /dev/bus/usb:/dev/bus/usb -v /home/<YOUR_WORKING_DIRECTORY_PATH>/docker-ionic/data:/home/ -e HOST_USER_NAME=$USERNAME -e HOST_USER_ID=$UID -e HOST_GROUP_NAME=$(id -g -n $USER || echo $USER) -e HOST_GROUP_ID=$(id -g $USER) ionic-image /bin/bash
$ docker exec -it ionic /bin/bash
```

Notice that the exposed ports (both server and usb paths) may change according to your local machine. Also, _/docker-ionic/data_ it's just a suggestions for directory to be mapped.

Inside the container, don't forget to change to your user in case you want to edit files from an editor in Host:

```bash
su <YOUR_USER_NAME>
cd /home/<YOUR_USER_FOLDER>
```

This will leave you in the folder mapped during `run` command.
Once you're inside your docker container and folder, you can follow usual workflow to an Ionic project:
```
git clone *some_ionic_repository* OR ionic start myApp sidemenu
cd myApp
npm install
ionic serve --external OR ionic cordova run Android.
```

If you plan to run `ionic serve --external` or `ionic cordova run browser --external`, remember to have your ports free.
If you plan to run `ionic cordova run android`, make sure to:
 - Have your phone plugged and with proper USB connection mode (PTP, sometimes MTP).
 - In case you have adb on your host machine, run `adb kill-server` there, then `adb devices` in your docker.

This repository doesn't support any Android Emulator yet. Credits to [this repository](https://hub.docker.com/r/agileek/ionic-framework/), which helped me build the Dockerfile.
