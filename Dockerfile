FROM quay.io/ukhomeofficedigital/openjdk8:v1.8.0.161

ENV NVM_VER=v0.33.11
ENV NODE_VER=--lts
ENV SONAR_SCANNER_VER=3.1.0.1141
ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.digital.homeoffice.gov.uk/"
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}

RUN yum clean all && \
    yum update -y && \
    yum install -y wget curl unzip git && \
    yum clean all && \
    rpm --rebuilddb

# Install sonar-scanner
RUN wget -O /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip \
    https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip && \
    unzip /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip -d /opt/ && \
    rm -rf /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VER}/install.sh | bash && \
    . /root/.nvm/nvm.sh && \
    nvm install ${NODE_VER} && \
    nvm use ${NODE_VER}

CMD /opt/sonar-scanner-${SONAR_SCANNER_VER}/bin/sonar-scanner
