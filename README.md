# README

## Intro

PCFer is a reference app to handle supply-chain PCF requests in an automated, machine-readable way. It lets you both create digital PCF files to send to customers, and to receive them from vendors.

It uses the [PACT format for product-level greenhouse gas emissions](https://wbcsd.github.io/data-exchange-protocol/v2/), created by the WBCSD's [Pathfinder Network](https://www.wbcsd.org/Programs/Climate-and-Energy/Climate/SOS-1.5/Resources/Pathfinder-Framework-Guidance-for-the-Accounting-and-Exchange-of-Product-Life-Cycle-Emissions) with input from [RMI](https://rmi.org).

This basic app is for generic supply chain products, later versions will support fields specific to particular products, such as steel, based on the [steel accounting guidance](https://github.com/rmi/steel-guidance) created by RMI.

![ScreenShot](supnet_screenshot.png)

## Running it

This repo runs four containers, two postgres DBs, and two rails app--independed apps running the same code base, built and launched by docker-compose.yml. This is to allow demonstration of PACT-format files being shared between buyer and seller, if you simply want to run your own instance of the app, you can run the Dockerfile by itself. To run the whole thing:

1. Install Docker

2. Clone this repo
```
git clone https://github.com/rmi/pcfer.git
```

3. cd into repo and build images. The app was originally name supnet and the Rails app retains that name; until that gets changed (soon) the volume needs to retain it.

```
cd pcfer
docker build -t pcfer-toolbox -f Dockerfile.rails .

docker volume create --name seller-postgres
docker volume create --name buyer-postgres
docker volume create --name supnet
```

4. Initialize:

```
docker compose up --build
```

5. Connect to the shell running in the container. First run `docker ps` to list running containers, then, using the container name you just found, connect to it:

```
docker ps
docker exec -t -i pcfer-seller-pcfer-1 /bin/bash
docker exec -t -i pcfer-buyer-pcfer-1 /bin/bash
```

6. After building for the first time you'll see you need to create the databases. ctl-c, then run:

```
docker compose run pcfer rails db:create
docker compose run pcfer rails db:migrate
```

7. Once the database is set up, you can start the containers normally:

```
docker compose up
```

You should then be able to hit it at http://localhost:3000, and just run `docker compose up` any time you want to start the app+db container

## Connecting to the database
`psql --host=localhost --username=pcfer --port=6544 --dbname=pcfer`

buyer's db port is 6544, seller's is 6543 (mapped in both cases to the standard postgresql on the container side)

## CURL
To send PCF data via command line. The API key should be the one supplied by the Vendor.

`curl -v -H 'Content-Type: application/json' -H 'X-API-Key: sk_J8HcZp4OJxS3Rq4EdwVGdg' -d "@test_pact.json" -X POST http://localhost:3000/products.json`

## Sources

Portions of the docker setup were taken from:
https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

## License
Copyright (c) 2023 John McGrath (jmcgrath@rmi.org) and [RMI](https://rmi.org). See [LICENSE][] for
details.

[license]: LICENSE.md