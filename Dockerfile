FROM quay.io/ukhomeofficedigital/openjdk8:v1.8.0.131

ENV SONAR_SCANNER_VER=3.0.1.733
ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.digital.homeoffice.gov.uk/"
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}

RUN yum clean all && \
    yum update -y && \
    yum install -y wget curl unzip git && \
    yum clean all && \
    rpm --rebuilddb

#Install sonar-scanner
RUN wget -O /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip \
    https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip && \
    unzip /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip -d /opt/ && \
    rm -rf /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip

ENTRYPOINT ["sonar-scanner"]
