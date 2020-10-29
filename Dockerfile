FROM quay.io/ukhomeofficedigital/openjdk11:v11.0.5_10_centos8-rc3
ENV SONAR_SCANNER_VER=4.5.0.2216
ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.testing.acp.homeoffice.gov.uk/"
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}


 RUN dnf clean all  \
  && dnf install langpacks-en glibc-all-langpacks -y
  && dnf autoremove -y \
  && dnf update -y --exclude filesystem*  \
  && dnf clean all -y \
  && dnf install -y wget curl unzip git python3-pip \
  && rm -rf /var/cache/dnf


#for ansible plugins
RUN pip3 install ansible-lint

#Install sonar-scanner
RUN wget -O /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip \
    https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip && \
    unzip /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip -d /opt/ && \
    rm -rf /tmp/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip

ENTRYPOINT ["sonar-scanner"]
