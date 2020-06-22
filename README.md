# Shibwright

[![Build Status](https://travis-ci.org/Digital-Identity-Labs/shibwright.svg?branch=master)](https://travis-ci.org/Digital-Identity-Labs/shibwright)
[![Docker Stars](https://img.shields.io/docker/stars/digitalidentity/shibwright.svg)](https://hub.docker.com/r/digitalidentity/shibwright/)
[![Image Details](https://images.microbadger.com/badges/image/digitalidentity/shibwright.svg)](https://microbadger.com/images/digitalidentity/shibwright "Get your own image badge on microbadger.com")

## What is this?

[Shibboleth Identity Provider](https://www.shibboleth.net/products/identity-provider/) is a mature, SAML-based 
single sign on (SSO) web application widely deployed in academic organisations. It's used by millions of staff and 
students around the world.

Shibwright is a lazy and inefficient alternative way to install or update the Shibboleth IdP software.
It is maintained by [Digital Identity Ltd.](http://digitalidentity.ltd.uk/). We're not sure how useful it actually is.
Shibwright uses a Docker container to run the Shibboleth IdP installer on the local directory. It does not actually run
the IdP software itself - you will need a Java web container such as Tomcat or Jetty, either installed locally or in a
Docker container.

## Why use this?

* You are running the Shibboleth IdP in a Docker container and need to create or update configuration files
* Your configuration is managed in a git repository and edited locally
* You want to update configuration files on a computer without Java
* You need to update a series of IdP installations slightly quicker

## Any reasons not to use this?

* It's an entire operating system and Java JDK just run an install script

## Configuring and running Shibwright

### Getting the image

Please check that Shibwright contains the latest version of the Shibboleth IdP before using it.

`docker pull digitalidentity/shibwright`

### Using Shibwright

The easiest way to use Shibwright is to create a shell alias

```bash
alias shibwright="docker run -it -v $PWD:/opt/shibboleth-idp --rm digitalidentity/shibwright"
```

After creating the alias you can run shibwright with `shibwright`.

Shibwright will mount your *current directory* as the default install location `/opt/shibboleth-idp` - use the installer as
if that's where you installing to, and the files will be created in your current directory.

Adjust the files to suit your use-case - see the
 [Shibboleth IdP documentation](https://wiki.shibboleth.net/confluence/display/IDP30/Home) for lots more information.

### Related Projects from Digital Identity

* [Ishigaki](https://github.com/Digital-Identity-Labs/ishigaki/) - a Docker image for *running* the Shibboleth IdP.

### Thanks
* We're just packaging huge amounts of work by [The Shibboleth Consortium](https://www.shibboleth.net/consortium/) and
 the wider Shibboleth community. If your organisation depends on Shibboleth please consider supporting them.

### Contributing
You can request new features by creating an [issue](https://github.com/Digital-Identity-Labs/shibwright/issues), or
submit a [pull request](https://github.com/Digital-Identity-Labs/shibwright/pulls) with your contribution.

If you have a support contract with Mimoto, please [contact Mimoto](http://mimoto.co.uk/contact/) for assistance, rather
 than use Github.

### License
Copyright (c) 2020 Digital Identity Ltd, UK

Licensed under the MIT License
