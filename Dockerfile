#### Creates an environement containing java 8, android SDKs, node, python, git, cordova and ionic.
FROM ubuntu:18.04

MAINTAINER mateus [dot] m [dot] luna [at] gmail [dot] com 

### JAVA -------------------------------------------------------------

	# Install JAVA and software-properties-common (so you can do add-apt-repository)
    RUN set -x && \
		apt-get update && \
		apt-get install -y -q wget software-properties-common curl openjdk-8-jre openjdk-8-jdk

    ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

### Android SDKs ------------------------------------------------------

    ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.5-linux.zip" \
		ANDROID_BUILD_TOOLS_VERSION=26.1.1 \
		ANDROID_APIS="android-29" \
		ANT_HOME="/usr/share/ant" \
		MAVEN_HOME="/usr/share/maven" \
		GRADLE_HOME="/usr/share/gradle" \
		ANDROID_HOME="/opt/android-sdk-linux"

    ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

    # Extra packages
    RUN /usr/bin/dpkg --add-architecture i386 
    RUN apt-get update && \
		apt-get install -y libstdc++6:i386 zlib1g:i386 unzip adb

    # Download and extract Android SDK
    RUN mkdir /opt/android-sdk-linux
    RUN wget --output-document=tools_r25.2.5-linux.zip $ANDROID_SDK_URL
    RUN unzip "tools_r25.2.5-linux.zip" -d /opt/android-sdk-linux && \
		ls -la /opt/android-sdk-linux && \
		chmod a+x -R $ANDROID_HOME && \
		chown -R root:root $ANDROID_HOME

    # Install Gradle
    RUN	add-apt-repository ppa:cwchien/gradle -y && \
		apt-get update  && \
		apt-get install gradle -y

    # Accept Licenses
    RUN apt-get update && \
		apt-get install -y expect
    COPY tools /opt/tools

    RUN chmod a+x /opt/tools/android-accept-licenses.sh
    RUN ls -la /opt/tools
    RUN ["/usr/bin/expect", "/opt/tools/android-accept-licenses.sh", "/opt/android-sdk-linux/tools/android update sdk --all --force --no-ui"]

### NodeJS -----------------------------------------------------------

    ENV NODEJS_VERSION=12.16.3 \
    NPM_VERSION=6.14.4

    RUN apt-get -qq update && \
		wget --output-document=node.tar.gz "http://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-linux-x64.tar.gz" && \
		tar -xzf "node.tar.gz" -C /usr/local --strip-components=1 && \
		npm install -g npm@"$NPM_VERSION" && \
		ls -la && \
		cd ../.. && \

		# Clean up
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
		apt-get purge -y software-properties-common &&\
		apt-get autoremove -y && \
		apt-get clean

### Python, & Git -------------------------------------------------

    RUN apt-get -qq update && \
		apt-get -qq install -y git --no-install-recommends
    RUN apt-get -qq update && \
		apt-get -qq install -y python && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
		apt-get autoremove -y && \
		apt-get clean


### Ionic and Cordova ---------------------------------------------
    RUN npm install -g cordova@latest && \
		npm install -g ionic@latest && \
		npm cache verify

    # Create, build, delete an empty cordova project to download necessary maven files and keep them in image
    RUN cordova create tmp-project && \
    	cd tmp-project && \
     	cordova platform add android && \
     	cordova build && \
     	cd .. && \ 
     	rm -rf tmp-project

### User script ---------------------------------------------------

	RUN apt-get update && \
		apt-get install -y sudo && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
		apt-get autoremove -y && \
		apt-get clean
	RUN chmod a+x /opt/tools/init-user.sh

### Final setup--------------------------------------------------

	EXPOSE 8100 35729
	ENTRYPOINT ["/opt/tools/init-user.sh"]

