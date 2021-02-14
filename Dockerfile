# can also be x64 if using that platform
FROM debian:10-slim

ARG CORETTO_ARCH=aarch64

# install corretto jdk 11, curl, git, unzip, sdkman, kotlin , blade, flutter sdk 1.22
# will also pull a fresh lr7.3ga6 workspace to load base liferay dependencies and bundle, as well as gradle wrapper binaries
RUN apt update \
    && apt install -y \
    curl \
    git  \
    java-common \
    unzip zip tar gzip xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L -O https://corretto.aws/downloads/latest/amazon-corretto-11-${CORETTO_ARCH}-linux-jdk.deb && mkdir -p /usr/share/man/man1 && dpkg --install amazon-corretto-11-${CORETTO_ARCH}-linux-jdk.deb && rm amazon-corretto-11-${CORETTO_ARCH}-linux-jdk.deb \
    && curl -L -O https://raw.githubusercontent.com/jpm4j/jpm4j.installers/master/dist/biz.aQute.jpm.run.jar && java -jar biz.aQute.jpm.run.jar init && jpm install -f https://releases.liferay.com/tools/blade-cli/latest/blade.jar && rm biz.aQute.jpm.run.jar \
    && curl -s https://get.sdkman.io | bash &&  /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install kotlin \
    && curl https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.22.6-stable.tar.xz -o flutter-sdk.tar.xz && ls -la && tar xf flutter-sdk.tar.xz" && rm flutter-sdk.tar.xz

ENV PATH="/flutter/bin:${PATH}"

ADD workspace /initial_wsp

RUN cd /initial_wsp && ./gradlew distBundle && cd - && rm -rf /initial_wsp

ENTRYPOINT [ "bash" ]

