FROM bitnami/minideb:latest

LABEL description="An inelegant, inefficient and pleasantly lazy way to install and update Shibboleth IdP files" \
      version="0.1.0" \
      maintainer="pete@digitalidentitylabs.com"

ARG SRC_DIR=/usr/local/src
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ARG IDP_URL=https://shibboleth.net/downloads/identity-provider/latest4/shibboleth-identity-provider-4.0.1.tar.gz
ARG IDP_CHECKSUM=832f73568c5b74a616332258fd9dc555bb20d7dd9056c18dc0ccf52e9292102a

ENV JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto \
    ADMIN_HOME=/opt/admin \
    IDP_HOME=/opt/shibboleth-idp \
    IDP_HOSTNAME=idp.example.com IDP_SCOPE=example.com IDP_ID=https://idp.example.com/idp/shibboleth

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

RUN echo "\n## Installing Shibboleth IdP..." && \
    curl -o idp.tgz $IDP_URL && \
    echo "${IDP_CHECKSUM} idp.tgz" > idp.tgz.sha256 && sha256sum -c idp.tgz.sha256 && \
    mkdir -p idp_src && tar -zxf idp.tgz -C idp_src --strip-components 1 && \
    rm -rf idp_src/bin/*.bat && \
    echo "idp.entityID=$IDP_ID" > $SRC_DIR/temp.properties && \
    idp_src/bin/install.sh -Didp.src.dir=/usr/local/src/idp_src -Didp.target.dir=/opt/shibboleth-idp \
      -Didp.host.name=$IDP_HOSTNAME -Didp.scope=$IDP_SCOPE \
      -Didp.sealer.password=password -Didp.keystore.password=password \
      -Didp.noprompt=true -Didp.merge.properties=$SRC_DIR/temp.properties

WORKDIR /opt/shibboleth_idp

ENTRYPOINT ["/usr/local/src/idp_src/bin/install.sh"]
CMD []