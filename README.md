# rstudio-rmarkdown-primer
Primer for creating R Markdown documents with RStudio

This is very much work in progress and also a personal but not private knowledge base.

Those new to RStudio might want to read [getting-started.md](./getting-started.md).

If you want to check your RStudio setup open [helloWorld.Rmd](./helloWorld.Rmd) and "knit" it.

New RMarkdown documents focus on a topic and are placed under a topic specific sub-folder under the `topic` folder.
TBD: List of topics w/ references to each document, ideally auto-generated or auto-modified.

## Setup

### RStudio Setup

I am running RStudio as a `docker/podman` container:

- run an isolated sandbox: [rocker-getting-started-sanboxed.md](hello-world/rocker-getting-started-sanboxed.md)
- run a reusable installation: [getting-started.md](./getting-started.md)

Until a docker/podman container is created see also: [rstudio-mounted-install-pkg.md[(./rstudio-mounted-install-pkg.md).

As for further reading on launching RStudio in Docker, see also:

- [Launching RStudio in Docker](https://jsta.github.io/r-docker-tutorial/02-Launching-Docker.html)
- [Running RStudio Server with Docker - Dave Tang's blog](https://davetang.org/muse/2021/04/24/running-rstudio-server-with-docker/)
- [davetang/learning_docker · GitHub](https://github.com/davetang/learning_docker/tree/main/rstudio)

### RStudio Add-In

See [install-add-in.md](./install-add-in.md).

### Snippets

See [r-snippet-links.md](./r-snippet-links.md) and [r-snippets.Rmd](./r-snippets.Rmd)

## Introduction

### Hello World

A simple [rocker-getting-started-sanboxed.md](./hello-world/rocker-getting-started-sanboxed.md) markdown document explains
how to create your first, simple RMarkdown document.

You can open [helloWorld.Rmd](./helloWorld.Rmd) and Knit it to check your installation.

### Introduction into Literate Programming

An more feature rich introduction than the simple "Hello World" examples is provided
in form of the [Literate-Programming.Rmd](./topic/distribution-shape/Literate-Programming.Rmd) RMarkdown document.
You can view its [Markdown output](./topic/distribution-shape/Literate-Programming.md), it covers:

- what "Literate Programming" is about and why it is useful,
- basic Markdown concepts (bold, italic, lists, images, links)
- basic RMarkdown concepts (code changes, plots charts, normal distribution, output targets, help),
- mathematical formula in a document
- how to use a simulation by illustrating the difference between biased on non biased variance estimators,
- R session info

## Topics Overview

- Basics
  - basic skills for text formatting, math equations, curves and plots, and editor modes, see [text-formatting](./topic/basics/text-formatting.Rmd)
  - show tables statically or dynamically, see [data-frames-and-tibbles](./topic/basics/data-frames-and-tibbles.Rmd)
- Cluster
  - code samples for Probabilistic Distance Clustering, see [pdq-fitting-data-to-model](./topic/cluster/pdq-fitting-data-to-model.Rmd)
- JSON
  - tidyJSON: features word cloud, JSON document graph, build-in JSON editor, Violin plot, see [setup-tidyjson](./topic/json/setup-tidyjson.Rmd)
  - PlantUML: visual representation of JSON object structure or class structure, see [use-plantuml](./topic/json/use-plantuml.Rmd)
- Output Format:
  - benefit of various output formats such as `readthedown`, see [output-format-links](./topic/output-format/output-format-links.Rmd)
- PCA
  - an introduction into principal component analysis (PCA), see [pca-introduction](./topic/pca/pca-introduction.Rmd)

Same as above but pointing the links to the generated Markdown files which display nicer on Github:

- Basic
  - basic skills for text formatting, math equations, curves and plots, and editor modes, see [text-formatting](./topic/basics/text-formatting.md)
  - show tables statically or dynamically, see [data-frames-and-tibbles](./topic/basics/data-frames-and-tibbles.md)
- Cluster
  - code samples for Probabilistic Distance Clustering, see [pdq-fitting-data-to-model](./topic/cluster/pdq-fitting-data-to-model.md)
- JSON
  - tidyJSON: features word cloud, JSON document graph, build-in JSON editor, Violin plot, see [setup-tidyjson](./topic/json/setup-tidyjson.md)
  - PlantUML: visual representation of JSON object structure or class structure, see [use-plantuml](./topic/json/use-plantuml.md)
- Output Format:
  - benefit of various output formats such as `readthedown`, see [output-format-links](./topic/output-format/output-format-links.md)
- PCA
  - an introduction into principal component analysis (PCA), see [pca-introduction](./topic/pca/pca-introduction.md)

> TBD: Generated an overview to each topic and the documents within.

## Future Topics

See [future-topics.Rmd](./future-topics.Rmd)

