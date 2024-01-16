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

## Hello World

You can open [helloWorld.Rmd](./helloWorld.Rmd) and Knit it to check your installation.

## Topics Overview

> TBD: Generated an overview to each topic and the documents within.

## Future Topics

See [future-topics.Rmd](./future-topics.Rmd)





