# Getting Started

Based on me running RStudio 2022.12.0 Build 353 as a `podman` container on Fedora 37.
The `podman` container runs Ubuntu 22.04.2 LTS.

## TL;DR

In order to get running:

1. launch RStudio
2. install required OS packages (if needed)
3. install R packages (as needed)

All of these steps are covered below.

If you are new to RStudio then you may want to watch one of the many
RStudio introduction videos (not covered in this document).

### RStudio Launch

You can either install RStudio natively on Mac OS/X, Microsoft Windows, or Linux.
Or you can run it in a `docker` container.

For the **native installation** consult the excellent RStudio (now Posit) web pages:

* [RStudio Desktop - Posit](https://posit.co/download/rstudio-desktop/)
* [Download RStudio | The Popular Open-Source IDE from Posit](https://posit.co/products/open-source/rstudio/)

If you are using `docker` or `podman` have a look at [docker-run-rstudio-mounted-volumes.sh](../scripts/docker-run-rstudio-mounted-volumes.sh)

The core of the shell script:

```bash
if [[ -z "${PASSWORD}" && -f ~/.secrets/local/docker/rstudio/env-sops.yaml ]]; then PASSWORD=$(sops --decrypt --extract '["PASSWORD"]' ~/.secrets/local/docker/rstudio/env-sops.yaml); fi
PASSWORD=${PASSWORD:-change_me}

podman run --rm -ti --name rstudio_mounted -p 8788:8787 \
	-v ${HOME}/r_packages/site-library:/usr/local/lib/R/site-library:Z \
	-v ${HOME}/Documents/rstudio:/home/rstudio/rstudio:Z \
	-e PASSWORD=${PASSWORD} \
	-e USERID=$(id -u) \
	-e GROUPID=$(id -g) \
	rocker/rstudio

unset PASSWORD
```

The shell script uses `sops` to handle the encrypted password in a safe way.
One can not set it and use the random generated one or use other options instead
of `sops` if one does not have `sops`. The benefit of using the same password
is that one can store it in the web browser.

The shell script is also mounting two folders which must be created with the appropriate permission

- `${HOME}/r_packages/site-library`: such that packages survive `podman` image restart
- `${HOME}/Documents/rstudio`: working folder for R projects

> To add files to the work space best use the `Upload` button under `Files` in the
> forth quadrant (south/west).

Creating shared folder with group-write and sticky bit set and set owner to `podman` user:
  
```bash
mkdir -p ${HOME}/r_packages/site-library
podman unshare chown -R $(id -u):$(id -g) ${HOME}/r_packages/site-library

mkdir -p ${HOME}/Documents/rstudio
chmod -R g+w ${HOME}/Documents/rstudio
chmod -R g+s ${HOME}/Documents/rstudio
podman unshare chown -R $(id -u) ${HOME}/Documents/rstudio
```

Here is the `stat` output on my system as reference:

```bash
$ stat ${HOME}/r_packages/site-library
  File: /home/marco/r_packages/site-library
  Size: 12288     	Blocks: 24         IO Block: 4096   directory
Device: 253,2	Inode: 1992796     Links: 296
Access: (0755/drwxr-xr-x)  Uid: (100999/ UNKNOWN)   Gid: ( 1000/   marco)
Context: system_u:object_r:container_file_t:s0:c304,c732

$ stat ${HOME}/Documents/rstudio
  File: /home/marco/Documents/rstudio
  Size: 4096      	Blocks: 16         IO Block: 4096   directory
Device: 253,2	Inode: 1992531     Links: 4
Access: (0775/drwxrwxr-x)  Uid: ( 1000/   marco)   Gid: ( 1000/   marco)
Context: system_u:object_r:container_file_t:s0:c304,c732
```

> Next: Install required OS packages to get Knitr to work and PostgreSQL queries.

### OS Packages

These installs must be run as

* without the first `Knitr` won't work on Linux and 
* w/o the second one can not run SQL queries against a PostgreSQL database

For the operating system packages first connect to the `podman` container:

```bash
podman exec -it rstudio_mounted /bin/bash
```

Then run from the shell:

```bash
apt update
apt-get install -y xvfb xauth xfonts-base
apt-get install -y libpq-dev
```

**TO-DO**: I will create my own docker image w/ all OS packages pre-installed.

> Next: Install R packages as needed.

### R Packages

Which **R packages** are needed depends on what you want to use.

The user friendly way (GUI) to **install R packages** is to either use:

- `Tools | Install Packages`
- In the 4th quadrant select `Packages` from `Files, Plots, Packages, Help, ...`

The latter lists all available packages along with a short description which
might be helpful if you are just browsing around.

If you prefer a command style (CLI) you can use the R Console and run:

```r
# commonly used to diplay SQL query results
install.packages("DT")          # nice JavaScript powered tables
install.packages("RPostgreSQL") # needed to run SQL against PostgreSQL

# more commonly used packages
install.packages("lubriate")    # now() function and other date functions
install.packages("kableExtra)   # construct complex tables, dynamic reporting
install.packages("rstudioapi)   # safely access RStudio API
install.packages("shiny")       # build interactive web applications with R
```

The CLI command has the advantage that it is easier to communicate, document,
and automate.

## OS Package Fixes
 
### Fix X11 Display

When running Knit I got the something like the following error message:

```
Unable to open /usr/local/lib/R/modules/R_X11.so
```

To fix it I had to connect to the `podman` image:

```bash
podman exec -it rstudio_mounted /bin/bash
```

and run within the `podman image`:

```bash
apt update
apt-get install xvfb xauth xfonts-base
```

The expected output:

```
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libfontenc1 libice6 libsm6 libunwind8 libxaw7 libxfont2 libxkbfile1 libxmu6 libxmuu1 libxpm4 libxt6 x11-common x11-xkb-utils xfonts-encodings xfonts-utils xkb-data xserver-common
The following NEW packages will be installed:
  libfontenc1 libice6 libsm6 libunwind8 libxaw7 libxfont2 libxkbfile1 libxmu6 libxmuu1 libxpm4 libxt6 x11-common x11-xkb-utils xauth xfonts-base xfonts-encodings xfonts-utils xkb-data xserver-common xvfb
0 upgraded, 20 newly installed, 0 to remove and 101 not upgraded.
Need to get 8,836 kB of archives.
After this operation, 18.3 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu jammy/main amd64 xkb-data all 2.33-1 [394 kB]
Get:2 http://archive.ubuntu.com/ubuntu jammy/main amd64 libxmuu1 amd64 2:1.1.3-3 [10.2 kB]
Get:3 http://archive.ubuntu.com/ubuntu jammy/main amd64 xauth amd64 1:1.1-1build2 [27.5 kB]
Get:4 http://archive.ubuntu.com/ubuntu jammy/main amd64 libfontenc1 amd64 1:1.1.4-1build3 [14.7 kB]
Get:5 http://archive.ubuntu.com/ubuntu jammy/main amd64 x11-common all 1:7.7+23ubuntu2 [23.4 kB]
Get:6 http://archive.ubuntu.com/ubuntu jammy/main amd64 libice6 amd64 2:1.0.10-1build2 [42.6 kB]
Get:7 http://archive.ubuntu.com/ubuntu jammy/main amd64 libsm6 amd64 2:1.2.3-1build2 [16.7 kB]
Get:8 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 libunwind8 amd64 1.3.2-2build2.1 [54.5 kB]
Get:9 http://archive.ubuntu.com/ubuntu jammy/main amd64 libxt6 amd64 1:1.2.1-1 [177 kB]
Get:10 http://archive.ubuntu.com/ubuntu jammy/main amd64 libxmu6 amd64 2:1.1.3-3 [49.6 kB]
Get:11 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 libxpm4 amd64 1:3.5.12-1ubuntu0.22.04.1 [36.4 kB]
Get:12 http://archive.ubuntu.com/ubuntu jammy/main amd64 libxaw7 amd64 2:1.0.14-1 [191 kB]
Get:13 http://archive.ubuntu.com/ubuntu jammy/main amd64 libxfont2 amd64 1:2.0.5-1build1 [94.5 kB]
Get:14 http://archive.ubuntu.com/ubuntu jammy/main amd64 libxkbfile1 amd64 1:1.1.0-1build3 [71.8 kB]
Get:15 http://archive.ubuntu.com/ubuntu jammy/main amd64 x11-xkb-utils amd64 7.7+5build4 [172 kB]
Get:16 http://archive.ubuntu.com/ubuntu jammy/main amd64 xfonts-encodings all 1:1.0.5-0ubuntu2 [578 kB]
Get:17 http://archive.ubuntu.com/ubuntu jammy/main amd64 xfonts-utils amd64 1:7.7+6build2 [94.6 kB]
Get:18 http://archive.ubuntu.com/ubuntu jammy/main amd64 xfonts-base all 1:1.0.5 [5,896 kB]
Get:19 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 xserver-common all 2:21.1.4-2ubuntu1.7~22.04.1 [28.0 kB]
Get:20 http://archive.ubuntu.com/ubuntu jammy-updates/universe amd64 xvfb amd64 2:21.1.4-2ubuntu1.7~22.04.1 [863 kB]
Fetched 8,836 kB in 1s (6,752 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package xkb-data.
(Reading database ... 24640 files and directories currently installed.)
Preparing to unpack .../00-xkb-data_2.33-1_all.deb ...
Unpacking xkb-data (2.33-1) ...
Selecting previously unselected package libxmuu1:amd64.
Preparing to unpack .../01-libxmuu1_2%3a1.1.3-3_amd64.deb ...
Unpacking libxmuu1:amd64 (2:1.1.3-3) ...
Selecting previously unselected package xauth.
Preparing to unpack .../02-xauth_1%3a1.1-1build2_amd64.deb ...
Unpacking xauth (1:1.1-1build2) ...
Selecting previously unselected package libfontenc1:amd64.
Preparing to unpack .../03-libfontenc1_1%3a1.1.4-1build3_amd64.deb ...
Unpacking libfontenc1:amd64 (1:1.1.4-1build3) ...
Selecting previously unselected package x11-common.
Preparing to unpack .../04-x11-common_1%3a7.7+23ubuntu2_all.deb ...
Unpacking x11-common (1:7.7+23ubuntu2) ...
Selecting previously unselected package libice6:amd64.
Preparing to unpack .../05-libice6_2%3a1.0.10-1build2_amd64.deb ...
Unpacking libice6:amd64 (2:1.0.10-1build2) ...
Selecting previously unselected package libsm6:amd64.
Preparing to unpack .../06-libsm6_2%3a1.2.3-1build2_amd64.deb ...
Unpacking libsm6:amd64 (2:1.2.3-1build2) ...
Selecting previously unselected package libunwind8:amd64.
Preparing to unpack .../07-libunwind8_1.3.2-2build2.1_amd64.deb ...
Unpacking libunwind8:amd64 (1.3.2-2build2.1) ...
Selecting previously unselected package libxt6:amd64.
Preparing to unpack .../08-libxt6_1%3a1.2.1-1_amd64.deb ...
Unpacking libxt6:amd64 (1:1.2.1-1) ...
Selecting previously unselected package libxmu6:amd64.
Preparing to unpack .../09-libxmu6_2%3a1.1.3-3_amd64.deb ...
Unpacking libxmu6:amd64 (2:1.1.3-3) ...
Selecting previously unselected package libxpm4:amd64.
Preparing to unpack .../10-libxpm4_1%3a3.5.12-1ubuntu0.22.04.1_amd64.deb ...
Unpacking libxpm4:amd64 (1:3.5.12-1ubuntu0.22.04.1) ...
Selecting previously unselected package libxaw7:amd64.
Preparing to unpack .../11-libxaw7_2%3a1.0.14-1_amd64.deb ...
Unpacking libxaw7:amd64 (2:1.0.14-1) ...
Selecting previously unselected package libxfont2:amd64.
Preparing to unpack .../12-libxfont2_1%3a2.0.5-1build1_amd64.deb ...
Unpacking libxfont2:amd64 (1:2.0.5-1build1) ...
Selecting previously unselected package libxkbfile1:amd64.
Preparing to unpack .../13-libxkbfile1_1%3a1.1.0-1build3_amd64.deb ...
Unpacking libxkbfile1:amd64 (1:1.1.0-1build3) ...
Selecting previously unselected package x11-xkb-utils.
Preparing to unpack .../14-x11-xkb-utils_7.7+5build4_amd64.deb ...
Unpacking x11-xkb-utils (7.7+5build4) ...
Selecting previously unselected package xfonts-encodings.
Preparing to unpack .../15-xfonts-encodings_1%3a1.0.5-0ubuntu2_all.deb ...
Unpacking xfonts-encodings (1:1.0.5-0ubuntu2) ...
Selecting previously unselected package xfonts-utils.
Preparing to unpack .../16-xfonts-utils_1%3a7.7+6build2_amd64.deb ...
Unpacking xfonts-utils (1:7.7+6build2) ...
Selecting previously unselected package xfonts-base.
Preparing to unpack .../17-xfonts-base_1%3a1.0.5_all.deb ...
Unpacking xfonts-base (1:1.0.5) ...
Selecting previously unselected package xserver-common.
Preparing to unpack .../18-xserver-common_2%3a21.1.4-2ubuntu1.7~22.04.1_all.deb ...
Unpacking xserver-common (2:21.1.4-2ubuntu1.7~22.04.1) ...
Selecting previously unselected package xvfb.
Preparing to unpack .../19-xvfb_2%3a21.1.4-2ubuntu1.7~22.04.1_amd64.deb ...
Unpacking xvfb (2:21.1.4-2ubuntu1.7~22.04.1) ...
Setting up libxpm4:amd64 (1:3.5.12-1ubuntu0.22.04.1) ...
Setting up x11-common (1:7.7+23ubuntu2) ...
debconf: unable to initialize frontend: Dialog
debconf: (No usable dialog-like program is installed, so the dialog based frontend cannot be used. at /usr/share/perl5/Debconf/FrontEnd/Dialog.pm line 78.)
debconf: falling back to frontend: Readline
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of restart.
Setting up xkb-data (2.33-1) ...
Setting up libunwind8:amd64 (1.3.2-2build2.1) ...
Setting up libfontenc1:amd64 (1:1.1.4-1build3) ...
Setting up xfonts-encodings (1:1.0.5-0ubuntu2) ...
Setting up libxkbfile1:amd64 (1:1.1.0-1build3) ...
Setting up libxfont2:amd64 (1:2.0.5-1build1) ...
Setting up libxmuu1:amd64 (2:1.1.3-3) ...
Setting up libice6:amd64 (2:1.0.10-1build2) ...
Setting up xfonts-utils (1:7.7+6build2) ...
Setting up xfonts-base (1:1.0.5) ...
Setting up xauth (1:1.1-1build2) ...
Setting up libsm6:amd64 (2:1.2.3-1build2) ...
Setting up libxt6:amd64 (1:1.2.1-1) ...
Setting up libxmu6:amd64 (2:1.1.3-3) ...
Setting up libxaw7:amd64 (2:1.0.14-1) ...
Setting up x11-xkb-utils (7.7+5build4) ...
Setting up xserver-common (2:21.1.4-2ubuntu1.7~22.04.1) ...
Setting up xvfb (2:21.1.4-2ubuntu1.7~22.04.1) ...
Processing triggers for fontconfig (2.13.1-4.2ubuntu5) ...
Processing triggers for libc-bin (2.35-0ubuntu3.1) ...
```

### Install R Package RPostgreSQL Fails

Took about one minute.

```
** Installing R Packages: 'kableExtra', 'RPostgreSQL', 'rstudioapi', 'shiny'
[1/15] Installing xml2...
...
✔ Packages successfully installed.
Warning message:
In utils::install.packages("RPostgreSQL", repos = "https://packagemanager.posit.co/cran/__linux__/jammy/latest") :
  installation of package ‘RPostgreSQL’ had non-zero exit status
```

One must scroll up in the `Background Jobs` to see the error:

```
The downloaded source packages are in
	‘/tmp/Rtmp3VZK14/downloaded_packages’
Installing package into ‘/usr/local/lib/R/site-library’
(as ‘lib’ is unspecified)
trying URL 'https://packagemanager.posit.co/cran/__linux__/jammy/latest/src/contrib/RPostgreSQL_0.7-5.tar.gz'
Content type 'binary/octet-stream' length 579496 bytes (565 KB)
==================================================
downloaded 565 KB

* installing *source* package ‘RPostgreSQL’ ...
** package ‘RPostgreSQL’ successfully unpacked and MD5 sums checked
** using staged installation
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
checking for pg_config... no
configure: checking for PostgreSQL header files
configure: Checking include /usr/include.
configure: Checking include /usr/include/postgresql.
configure: Checking include /usr/local/include.
configure: Checking include /usr/local/include/postgresql.
configure: Checking include /usr/local/pgsql/include.
configure: Checking include /usr/local/postgresql/include.
configure: Checking lib /usr/lib.
configure: Checking lib /usr/lib/postgresql.
configure: Checking lib /usr/local/lib.
configure: Checking lib /usr/local/lib/postgresql.
configure: Checking lib /usr/local/postgresql/lib.
-I -L conftest.c -lpq -o pqconftest
./pqconftest
system -lpq don't appear to work; use internal
checking for "/libpq-fe.h"... no
./configure: line 1997: -I: command not found
./configure: line 1999: ./pqconftest: No such file or directory
configure: creating ./config.status
config.status: creating src/Makevars
gcc -I"/usr/local/lib/R/include" -DNDEBUG -I  -I/usr/local/include   -fpic  -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g  -c RS-DBI.c -o RS-DBI.o
** libs
gcc -I"/usr/local/lib/R/include" -DNDEBUG -I  -I/usr/local/include   -fpic  -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g  -c RS-PQescape.c -o RS-PQescape.o
In file included from RS-PQescape.c:7:
RS-PostgreSQL.h:23:14: fatal error: libpq-fe.h: No such file or directory
   23 | #    include "libpq-fe.h"
      |              ^~~~~~~~~~~~
compilation terminated.
make: *** [/usr/local/lib/R/etc/Makeconf:169: RS-PQescape.o] Error 1
ERROR: compilation failed for package ‘RPostgreSQL’
* removing ‘/usr/local/lib/R/site-library/RPostgreSQL’
```

### Fix PostGreSQL

Missing library:

1. Connect to the docker/podman container
1. Install the missing library
1. Install the R package from RStudio Console

```bash
# find the container name
podman ps

# connect to to
podman exec -it 027b685d4e61 /bin/bash

# inside the container run
apt-get update
apt-get install libpq-dev
```

In the RStudio Console panel run:

```bash
install.packages("RPostgreSQL")
```

You should see something like:

```
Installing package into ‘/usr/local/lib/R/site-library’
(as ‘lib’ is unspecified)
trying URL 'https://packagemanager.posit.co/cran/__linux__/jammy/latest/src/contrib/RPostgreSQL_0.7-5.tar.gz'
Content type 'binary/octet-stream' length 579496 bytes (565 KB)
==================================================
downloaded 565 KB

* installing *source* package ‘RPostgreSQL’ ...
...
** testing if installed package keeps a record of temporary installation path
* DONE (RPostgreSQL)

The downloaded source packages are in
	‘/tmp/RtmpUObeHo/downloaded_packages’
```

## R Packages Install

### Lubriate Package

The library `lubriate` is needed for R function `now()`.

```
Installing 'lubridate' ...
[1/2] Installing timechange...
Installing package into ‘/usr/local/lib/R/site-library’
(as ‘lib’ is unspecified)
trying URL 'https://packagemanager.posit.co/cran/__linux__/jammy/latest/src/contrib/timechange_0.2.0.tar.gz'
Content type 'binary/octet-stream' length 182026 bytes (177 KB)
==================================================
downloaded 177 KB

* installing *binary* package ‘timechange’ ...
[2/2] Installing lubridate...
* DONE (timechange)

The downloaded source packages are in
	‘/tmp/RtmppPh5Bs/downloaded_packages’
Installing package into ‘/usr/local/lib/R/site-library’
(as ‘lib’ is unspecified)
trying URL 'https://packagemanager.posit.co/cran/__linux__/jammy/latest/src/contrib/lubridate_1.9.2.tar.gz'
Content type 'binary/octet-stream' length 962315 bytes (939 KB)
==================================================
downloaded 939 KB

* installing *binary* package ‘lubridate’ ...
* DONE (lubridate)

The downloaded source packages are in
	‘/tmp/RtmppPh5Bs/downloaded_packages’


✔ Package 'lubridate' successfully installed.
```

### DT Package

The `DT` package is needed for `datatable()` for nice HTML display of tables
with filter and sorting.

In the R console run:

```r
install.packages("DT")
```
