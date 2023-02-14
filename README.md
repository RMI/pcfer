# README

## Intro

Sup!Net is a demo app to handle supply-chain PCF requests in an automated, machine-readable way. It lets you both create digital PCF files, and connect to other supnet nodes to get PCFs, or to incorporate their data into your own PCFs and improve them.

The demo uses the [PACT format for product-level greenhouse gas emissions](https://wbcsd.github.io/data-exchange-protocol/v2/), created by the WBCSD's Pathfinder Network. Using this data standard allows for interoperabity between independent nodes in a more fully-realized implementation of this idea.

This basic demo is for generic supply chain products, later versions may support fields specific to particular products.

![ScreenShot](supnet_screenshot.png)

## Running it

This repo runs two containers, one a postgres DB, the other a rails app. To run:

1. Install Docker

1. Clone this repo

```
git clone https://github.com/john/supnet.git
```

1. cd into repo and build images:

```
cd supnet
docker build -t supnet-toolbox -f Dockerfile.rails .
```

1. Initialize:

```
docker compose up --build
```

1. Connect to the shell running in the container. First run `docker ps` to list running containers, then, using the container name you just found, connect to it:

```
docker ps
docker exec -t -i supnet-supnet-1 /bin/bash
```

1. After building for the first time you'll see need to create the databases. ctl-c, then run:

```
docker compose run supnet rails db:create
docker compose run supnet rails db:migrate
```

1. Once the database is configured, you can start the containers normally:

```
docker compose up
```

You should then be able to hit it at http://localhost:3000, and just run `docker compose up` any time you want to start the app+db container

## TODO
- Add validation (required fields present, urns, dates)
- Form should have dropdown for set fields (ie, ISO Standard 14067 et al for crossSectoralStandardsUsed)
- Add UI indicator for required fields
- Add info mouseover explaining fields
- Simplified view to show only required and most common fields
- Add node selector for product requests to ingest outside data