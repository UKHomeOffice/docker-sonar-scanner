
FROM quay.io/ukhomeofficedigital/openjdk11:v11.0.5_11
ENV SONAR_SCANNER_VER=4.6.2.2472
ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.digital.homeoffice.gov.uk/"
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}


ENV  LANG en_US.UTF-8
ENV  LANGUAGE en_US.UTF-8
ENV  LC_ALL en_US.UTF-8

# to avoid set locale, defaulting to C.UTF-8
RUN  dnf  -y install glibc-langpack-en.x86_64

# =======================================

 RUN dnf clean all  \
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
