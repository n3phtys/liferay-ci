FROM debian:10-slim

ARG TARGETPLATFORM

# add flutter and ligo to path
ENV PATH="/flutter/bin:/ligo/build/install/ligo/bin:${PATH}"

# we add the liferay hello-world-portlet workspace (normally this would come later, but it should rarely change and is pretty small)
ADD workspace /initial_wsp

# install corretto jdk 11, curl, git, unzip, sdkman, kotlin , flutter sdk 1.22
# will also pull a fresh lr7.3ga6 workspace to load base liferay dependencies and bundle, as well as gradle wrapper binaries
RUN apt update \
    && apt install -y \
    curl \
    git  \
    java-common \
    unzip zip tar gzip xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && if [ $TARGETPLATFORM = linux/amd64 ]; \
    then curl -L https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.deb -o corretto_jdk.deb; \
    else curl -L https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-linux-jdk.deb -o corretto_jdk.deb; \
    fi \
    && mkdir -p /usr/share/man/man1 && dpkg --install corretto_jdk.deb && rm corretto_jdk.deb \
    #&& git clone https://github.com/n3phtys/ligo.git && cd ligo && chmod +x ./gradlew && ./gradlew installDist && cd - \
    && curl -s https://get.sdkman.io | bash \
    && /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install kotlin" \
    && curl https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.22.6-stable.tar.xz -o flutter-sdk.tar.xz && ls -la && tar xf flutter-sdk.tar.xz && rm flutter-sdk.tar.xz \
    && cd /initial_wsp && ./gradlew distBundle && cd - && rm -rf /initial_wsp

#ENTRYPOINT ["bash", "-c"]
