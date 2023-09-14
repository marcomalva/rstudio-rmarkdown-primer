#!/bin/bash
#
# to set explicit password user: -e PASSWORD=<YOUR_PASS>
#   using the same passwords allows the browser to remember the username/password making it more convenient
#   using sops to keep the password a secret but one I can easily share between my machines
#     to get a prompt for the GPG passphrase set export GPG_TTY=$(tty)
#     remember for sops to be working here I need to set e.g. export SOPS_PGP_FP="403B03...E4"
#         gpg -k | grep -C 3 $SOPS_PGP_FP
#   using sops in this matter is a crutch, longer term it is better to use 1password or doppler [Doppler | The #1 SecretOps Platform](https://www.doppler.com/)
# use rstudio via a web browser that points to http://localhost:8787
#
# login is rstudio/password
#
# On File | New File | R Markdown the following packages are installed:
#     'base64enc', 'digest', 'evaluate', 'glue', 'highr', 'htmltools', 'jsonlite', 'knitr', 'magrittr', 'markdown', 'mime', 'rmarkdown', 'stringi', 'stringr', 'xfun', 'yaml'
#
#
# # Creating shared folder with group-write and sticky bit set and set owner to podman user
#
#   mkdir -p ${HOME}/r_packages/site-library
#   podman unshare chown -R $(id -u):$(id -g) ${HOME}/r_packages/site-library
#
# # Creating shared folder with group-write and sticky bit set and set owner to podman user
#
#   mkdir -p ${HOME}/Documents/rstudio/shared
#   chmod -R g+w ${HOME}/Documents/rstudio/shared
#   chmod -R g+s ${HOME}/Documents/rstudio/shared
#   podman unshare chown -R $(id -u) ${HOME}/Documents/rstudio/shared

# -v ${HOME}/r_packages/site-library:/usr/local/lib/R/site-library:Z \
# -v ${HOME}/Documents/rstudio/rstudio_mounted:/home/rstudio/rstudio:Z \
#	-e USERID=$(id -u) \
#	-e GROUPID=$(id -g) \
#
# podman run --rm -ti --security-opt label=disable --name rstudio_mounted \
#

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
