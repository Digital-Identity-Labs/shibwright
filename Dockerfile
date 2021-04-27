FROM bitnami/minideb:latest

LABEL description="An inelegant, inefficient and pleasantly lazy way to install and update Shibboleth IdP files" \
      maintainer="pete@digitalidentitylabs.com" \
      org.opencontainers.image.source="https://github.com/Digital-Identity-Labs/shibwright"

ARG SRC_DIR=/usr/local/src
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ARG IDP_URL=https://shibboleth.net/downloads/identity-provider/latest4/shibboleth-identity-provider-4.1.0.tar.gz
ARG IDP_CHECKSUM=46fe154859f9f1557acd1ae26ee9ac82ded938af52a7dec0b18adbf5bb4510e9

ENV JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto \
    JETTY_HOME=/opt/jetty \
    JETTY_BASE=/opt/jetty-shib \
    ADMIN_HOME=/opt/admin \
    IDP_HOME=/opt/shibboleth-idp \
    INSTALLER_SCRIPTS=$SRC_DIR/idp_src/bin \
    IDP_SCRIPTS=$IDP_HOME/bin \
    PATH="${PATH}:${IDP_SCRIPTS}:${INSTALLER_SCRIPTS}"

WORKDIR $SRC_DIR

COPY aptfs .

RUN echo "\n## Installing Java..." && \
    install_packages gnupg unzip curl ca-certificates && \
    apt-key add corretto.key && \
    cp sources.list /etc/apt/ && \
    install_packages java-11-amazon-corretto-jdk && \
    rm -rfv $JAVA_HOME/lib/*.zip && \
    apt-get remove --auto-remove --yes --allow-remove-essential gnupg dirmngr unzip && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /usr/local/src/*

RUN echo "\n## Downloading and unpacking Shibboleth IdP..." && \
    curl -o idp.tgz $IDP_URL && \
    echo "${IDP_CHECKSUM} idp.tgz" > idp.tgz.sha256 && sha256sum -c idp.tgz.sha256 && \
    mkdir -p idp_src && tar -zxf idp.tgz -C idp_src --strip-components 1 && \
    rm -rf idp_src/bin/*.bat && \
    mkdir -p /opt/shibboleth-idp/bin

WORKDIR $IDP_HOME

CMD ["install.sh"]