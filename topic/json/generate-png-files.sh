#!/bin/bash
# generate the png files referenced by use-plantuml.Rmd
#
# run this on the host, requires a local pantuml server
#   which can be launched, for example, with podman/docker:
#   podman run -d -p 8080:8080 plantuml/plantuml-server:jetty
#
# Alternatively, I could use the java CLI from the RStudio | Terminal
#   or make the plantuml docker port accessible from the RStudio docker container
#
curl -X POST http://localhost:8080/png --data-binary @json_array.plantuml -o json_array.png
curl --output json_array_cli.png http://localhost:8080/png/SoWkIImgoIhEp-EgvbBoAyrDBSfCLh9IY3RKKJ3IKJ2ErU5I2YufoinBLm29AfKP9YhfA2YL6IM1AUDa9P0Af_pydDJ4F92AagBIL1s5jCISOY05uiHorN8vfEQbWEm00000
podman unshare chown -R $(id -u) *.png

# demonstrate using the jar file directly,
#   run anywhere you have java and the plantuml.jar file, such as inside the RStudio Terminal
echo
echo "Inside the RStudio | Terminal run"
echo "java -Djava.awt.headless=true -splash:no -jar /home/rstudio/.cache/R/plantuml/jar/plantuml.jar -tpng user_city.puml"
echo
