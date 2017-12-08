#### Creates an environement containing java 8, android SDKs, node, python, git, cordova and ionic.

MAINTAINER mateus [dot] m [dot] luna [at] gmail [dot] com 

FROM ubuntu:16.04

### JAVA -------------------------------------------------------------

	# Install python-software-properties (so you can do add-apt-repository)
    RUN set -x && \
		apt-get update && \
		apt-get install -y -q python-software-properties software-properties-common  && \

		add-apt-repository ppa:webupd8team/java -y && \
		echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
		apt-get update && apt-get -y install oracle-java8-installer && \
		apt-get install -y oracle-java8-set-default
     
    ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

### Android SDKs ------------------------------------------------------

    ENV ANDROID_SDK_URL="https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" \
		ANDROID_BUILD_TOOLS_VERSION=25.0.2 \
		ANDROID_APIS="android-25" \
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
    RUN wget --output-document=android-sdk.tgz http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
    RUN tar xzf "android-sdk.tgz" -C /opt/android-sdk-linux --strip-components=1 && \
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

    ENV NODEJS_VERSION=8.9.1 \
    NPM_VERSION=5.5.1

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

