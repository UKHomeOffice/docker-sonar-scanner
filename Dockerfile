FROM eclipse-temurin:25-jdk-alpine-3.22

ENV HOME /root
ENV JAVA_HOME /opt/java/openjdk
ENV PATH $PATH:$JAVA_HOME/bin

ENV SONAR_SCANNER_VER=7.3.0.5189
ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.digital.homeoffice.gov.uk/"
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apk update && \
    apk add --no-cache \
        wget \
        curl \
        unzip \
        git \
        python3 \
        py3-pip \
        bash && \
    rm -rf /var/cache/apk/*

# Install ansible-lint for ansible plugins
RUN pip3 install --no-cache-dir ansible-lint --break-system-packages

# Install sonar-scanner
RUN wget -O /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip \
    https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip && \
    unzip /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip -d /opt/ && \
    rm -rf /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip

ENTRYPOINT ["sonar-scanner"]
