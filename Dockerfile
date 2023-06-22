FROM amazoncorretto:11-al2023-jdk

# Non-Root Application User
ARG USER=sonar
ARG UID=1000

#JAVA ENVS
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

#SONAR Envs
ARG SONAR_SCANNER_VER
ARG SONAR_SCANNER_SHA512
ENV SONAR_SCANNER_OPTS="-Xmx512m -Dsonar.host.url=https://sonarqube.digital.homeoffice.gov.uk/"
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VER}/bin:${PATH}

RUN set -euxo pipefail ;\
  #Install dependencies
  dnf install --setopt=keepcache=false -y \
    ca-certificates \
    findutils \
    git \
    glibc-langpack-en \
    nodejs \
    python311 \
    python3-pip \
    shadow-utils \
    tar \
    unzip \
    wget ;\
  dnf clean all ;\
  #Add non-root user
  useradd --uid $UID --comment "" $USER ;\
  #Retreive ACP CAs
  git clone https://github.com/UKHomeOffice/acp-ca.git /tmp/acp-ca ;\
  mv /tmp/acp-ca/ca.pem /usr/share/pki/ca-trust-source/anchors/acp_root_ca.crt ;\
  mv /tmp/acp-ca/ca-intermediate.pem /usr/share/pki/ca-trust-source/anchors/acp_int_ca.crt ;\
  rm -rf /tmp/acp-ca ;\
  #Install Node JS
  #nvm install ${NODE_VERSION} ;\
  #Install python dependencies
  pip3 install ansible-lint ;\
  #Install sonar-scanner
  curl -Lo ./sonar-scanner.zip "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip" ;\
  echo "$SONAR_SCANNER_SHA512 ./sonar-scanner.zip" | sha512sum --strict --check - ;\
  unzip ./sonar-scanner.zip -d /opt/ ;\
  rm -f ./sonar-scanner.zip ;\
  # Update file permissions
  mkdir -p /etc/keys/ ;\
  chown -R $USER:$USER /etc/pki ;\
  chown -R $USER:$USER /etc/keys/ ;\
  chown -R $USER:$USER /etc/ssl/certs ;\
  chown -R $USER:$USER /usr/share/pki/ca-trust-source ; \
  update-ca-trust extract ;\
  update-ca-trust force-enable ;

USER $UID
ENTRYPOINT ["sonar-scanner"]
