# docker-jmeter
## Image on Docker Hub

Docker image for [Apache JMeter](http://jmeter.apache.org).
This Docker image can be run as the ``jmeter`` command.
Find Images of this repo on [Docker Hub](https://hub.docker.com/r/s1p19-cts/jmeter).

## Building

With the script [build.sh](build.sh) the Docker image can be build
from the [Dockerfile](Dockerfile) but this is not really necessary as
you may use your own ``docker build`` commandline. Or better: use one
of the pre-built Images from [Docker Hub](https://hub.docker.com/r/s1p19-cts/jmeter).

See end of this doc for more detailed build/run/test instructions (thanks to @wilsonmar!)

### Build Options

Build argumments (see [build.sh](build.sh)) with default values if not passed to build:

- **JMETER_VERSION** - JMeter version, default ``5.1.1``

## Running

The Docker image will accept the same parameters as ``jmeter`` itself, assuming
you run JMeter non-GUI with ``-n``.

There is a shorthand [run.sh](run.sh) command.
See [test.sh](test.sh) for an example of how to call [run.sh](run.sh).

## User Defined Variables

This is a standard facility of JMeter: settings in a JMX test script
may be defined symbolically and substituted at runtime via the commandline.
These are called JMeter User Defined Variables or UDVs.

See [test.sh](test.sh) and the [trivial test plan](tests/trivial/test-plan.jmx) for an example of UDVs passed to the Docker
image via [run.sh](run.sh).

See also: http://blog.novatec-gmbh.de/how-to-pass-command-line-properties-to-a-jmeter-testplan/

## Do it for real: detailed build/run/test

Contribution by @wilsonmar

1. In a Terminal/Command session, install Git, navigate/make a folder, then:

   ```
   git clone https://github.com/s1p19-cts/docker-jmeter.git
   cd docker-jmeter
   ```

1. Run the Build script to download dependencies, including the docker CLI:

   ```
   ./build.sh
   ```

   If you view this file, the <strong>docker build</strong> command within the script is for a specific version of JMeter and implements the <strong>Dockerfile</strong> in the same folder.

   If you view the Dockerfile, notice the `JMETER_VERSION` specified is the same as the one in the build.sh script. The FROM keyword specifies the Alpine operating system, which is very small (less of an attack surface). Also, no JMeter plug-ins are used.

   At the bottom of the Dockerfile is the <strong>entrypoint.sh</strong> file. If you view it, that's where JVM memory settings are specified for <strong>jmeter</strong> before it is invoked. PROTIP: Such settings need to be adjusted for tests of more complexity.

   The last line in the response should be:

   <tt>Successfully tagged s1p19-cts/jmeter:5.1.1</tt>

1. Run the test script:

   ```
   ./test.sh
   ```

   If you view the script, note it invokes the <strong>run.sh</strong> script file stored at the repo's root. View that file to see that it specifies docker image commands.

   File and folder names specified in the test.sh script is reflected in the last line in the response for its run:

   <pre>
   ==== HTML Test Report ====
   See HTML test report in tests/trivial/report/index.html
   </pre>

1. Switch to your machine's Folder program and navigate to the folder containing files which replaces files cloned in from GitHub:

   ```
   cd tests/trivial
   ```

   The files are:

   * jmeter.log
   * reports folder (see below)
   * test-plan.jmx containing the JMeter test plan.
   * test-plan.jtl containing statistics from the run displayed by the index.html file.


1. Navigate into the <strong>report</strong> folder and open the <strong>index.html</strong> file to pop up a browser window displaying the run report. On a Mac Terminal:

   ```
   cd report
   open index.html
   ```


## Specifics

The Docker image built from the
[Dockerfile](Dockerfile) inherits from the [Alpine Linux](https://www.alpinelinux.org) distribution:

> "Alpine Linux is built around musl libc and busybox. This makes it smaller
> and more resource efficient than traditional GNU/Linux distributions.
> A container requires no more than 8 MB and a minimal installation to disk
> requires around 130 MB of storage.
> Not only do you get a fully-fledged Linux environment but a large selection of packages from the repository."

See https://hub.docker.com/_/alpine/ for Alpine Docker images.

The Docker image will install (via Alpine ``apk``) several required packages most specificly
the ``OpenJDK Java JRE``.  JMeter is installed by simply downloading/unpacking a ``.tgz`` archive
from http://mirror.serversupportforum.de/apache/jmeter/binaries within the Docker image.

A generic [entrypoint.sh](entrypoint.sh) is copied into the Docker image and
will be the script that is run when the Docker container is run. The
[entrypoint.sh](entrypoint.sh) simply calls ``jmeter`` passing all argumets provided
to the Docker container, see [run.sh](run.sh) script:

```
docker run --name ${NAME} -i -v ${WORK_DIR}:${WORK_DIR} -w ${WORK_DIR} ${IMAGE} $@
```

## X11 Error on Mac
If you are running on Mac, you will see following error
```
An error occurred:
No X11 DISPLAY variable was set, but this program performed an operation which requires it.
```

If you want to fix it on Mac, you need to do few things:

* Install the latest XQuartz X11 server and run it
* Activate the option ‘Allow connections from network clients’ in XQuartz settings
* Quit & restart XQuartz (to activate the setting)
* Run the docker script

## Credits

Thank you to all for their great contributions.
