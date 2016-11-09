FROM quay.io/ukhomeofficedigital/openjdk8:v1.1.0

ENV SONAR_SCANNER_VER=2.8

ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=http://sonarqube.digital.homeoffice.gov.uk/"

RUN yum clean all && \
    yum update -y && \
    yum install -y wget curl unzip git && \
    yum clean all && \
    rpm --rebuilddb

#Install sonar-scanner
RUN wget -O /tmp/sonar-scanner-${SONAR_SCANNER_VER}.zip \
    https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-${SONAR_SCANNER_VER}.zip && \
    unzip /tmp/sonar-scanner-${SONAR_SCANNER_VER}.zip -d /opt/ && \
    rm -rf /tmp/sonar-scanner-${SONAR_SCANNER_VER}.zip

ENTRYPOINT ["sonar-scanner"]
