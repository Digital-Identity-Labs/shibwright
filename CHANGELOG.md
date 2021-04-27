# Changelog

## 1.0.0

Shibwright has proven itself to be embarrassingly useful so far but with the addition of new Idp scripts for managing 
modules and plugins, it needs to be able to run more than the install/upgrade script.

### Improvements

- Uses Shibboleth IdP v4.1.0
- With no command specified it will run the install.sh script as before
- Shibboleth scripts can be specified as the first parameter
- Search path checks /opt/shibboleth-idp/bin first, then /usr/local/src/idp_src/bin

### Releases
- Images are now available from Github as well as from Dockerhub. Only the default image is available at Docker Hub.

## 0.1.0

### Initial release
