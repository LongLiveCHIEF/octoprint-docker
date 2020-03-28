# Contributing

## Pre-requisites

A build environment that:
- supports docker multi-stage builds
- has `make` and `jq` commands available

### Building

 - [building images from latest stable release tag](#stable)
 - [building images from master](#master)
 - [alternate build configuration](#build-config)

<a name="stable"></a>**Building stable release images**
Running `make` will run a build that will result in 2 images based on the `Dockerfile`
one using python 2.7, and one using the latest slim-buster python tag from docker hub.

Resulting Tags/Images:

```
octoprint/octoprint:<version> (python 2.7)
octoprint/octoprint:<version>-python3
```

<a name="master"></a>**Building 'latest' from master**

Run `make build-master` or `make build-master-python3` to build the
corresponding images:

```
octoprint/octoprint:latest
octoprint/octoprint:python3
```

**Build Configurations**

The `make` command will pull in the `env.mk` file, and 
utilize the variables within during the various stages of build,
test, and release.

To build alternate infrastructures, or get use different base images
for end-use, you have a few options:

- change the variables in `env.mk`
- provide alternate saved configsets by using `cnf=<some_other_env.mk`
argument supplied to `make` (and creating/savig `some_other_env.mk`) 
- set the variables found in `env.mk` in the build environment or supply them to command line
to override the default configs
