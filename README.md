# README

## Intro

Sup!Net is a demo app to handle supply-chain PCF requests in an automated, machine-readable way. It lets you both create digital PCF files, and connect to other supnet nodes to get PCFs, or to incorporate their data into your own PCFs and improve them.

The demo returns data in the PACT format, created by the WBCSD's Pathfinder Network. Using this data standard will allow for interoperabity between independented nodes in a more fully-realized implementation of this idea.

This basic demo is for generic supply chain products, later versions may support fields specific to particular products.

The basic data flow is a fallback system: if a generic request is made for the carbon intensity of kerosene, a global average is returned. If the request includes location data, a regional or local average is used if available. If the request includes a specific kerosene vendor, the system looks to see if that vendor is running a Sup!Net node (in a full implementation there might be a lookup microservice for node discovery), and if one is found, it queries that API, and returns the specific carbon intensity supplied by the vendor.

## Running it

This repo runs two containers, one a postgres DB, the other a rails app. To run:

1. Install Docker

1. Clone this repo

1. From the top level of the repo, run this to build the images:

`docker build -t supnet-toolbox -f Dockerfile.rails .`

1. Initialize:
`docker compose up --build`

1. Connect to the shell running in the container. First run `docker ps` to list running containers, then, using the container name you just found, connect to it:
docker exec -t -i supnet-supnet-1 /bin/bash

1. After building for the first time you'll see need to create the databases. ctl-c, then run:

`docker compose run supnet rails db:create`
`docker compose run supnet rails db:create RAILS_ENV=test`

?? (not sure why I'm having to do this separately, I had thought dev and test both got created, for some reason that's not happening)??

`docker compose run supnet rails db:migrate`
`docker compose run supnet rails db:migrate  RAILS_ENV=test`

1. Once the database is configured, you can start the containers normally:
`docker compose up`

You should then be able to hit it at http://localhost:3000, and just run `docker compose up` any time you want to start the app+db container