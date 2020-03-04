FROM quay.io/ukhomeofficedigital/openjdk8:v1.8.0.212

ENV SONAR_SCANNER_VER=4.3.0.2102
ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.digital.homeoffice.gov.uk/"
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}

RUN yum clean all && \
    yum update -y --exclude filesystem* && \
    yum install -y wget curl unzip git python3-pip && \
    yum clean all && \
    rpm --rebuilddb

#for ansible plugins
RUN pip3 install ansible-lint

#Install sonar-scanner
RUN wget -O /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip \
    https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip && \
    unzip /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip -d /opt/ && \
    rm -rf /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip

ENTRYPOINT ["sonar-scanner"]
