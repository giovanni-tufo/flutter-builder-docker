FROM openjdk:8-jdk

MAINTAINER Giovanni Tufo <giovanni@gtconsulting.eu>

ENV ANDROID_COMPILE_SDK 28
ENV ANDROID_BUILD_TOOLS 28.0.3
ENV ANDROID_SDK_TOOLS 4333796
ENV FLUTTER_VERSION https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.9.1+hotfix.4-stable.tar.xz
ENV PATH "$PATH:/opt/android-sdk-linux/platform-tools/:/opt/flutter/bin"
ENV ANDROID_HOME "/opt/android-sdk-linux"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y wget unzip lib32stdc++6 lib32z1 xz-utils
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip\
  && unzip -d /opt/android-sdk-linux android-sdk.zip \
  && mkdir -p /root/.android\
  && touch /root/.android/repositories.cfg\
  && echo y | /opt/android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null\
  && echo y | /opt/android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null\
  && echo y | /opt/android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null\
  && yes | /opt/android-sdk-linux/tools/bin/sdkmanager --licenses
RUN wget --quiet --output-document=flutter-sdk.tar.xz ${FLUTTER_VERSION}\
  && tar -xf flutter-sdk.tar.xz -C /opt