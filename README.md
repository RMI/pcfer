# README

## Intro

PCFer is a reference app to handle supply-chain PCF requests in an automated, machine-readable way, created by RMI's [Climate Intelligence Program](https://rmi.org/our-work/climate-intelligence/). It lets you both create digital PCF files to send to customers, and to receive them from vendors.

It uses the [PACT format for product-level greenhouse gas emissions](https://wbcsd.github.io/data-exchange-protocol/v2/), created by the WBCSD's [Pathfinder Network](https://www.wbcsd.org/Programs/Climate-and-Energy/Climate/SOS-1.5/Resources/Pathfinder-Framework-Guidance-for-the-Accounting-and-Exchange-of-Product-Life-Cycle-Emissions) with input from [RMI](https://rmi.org).

This basic app is for generic supply chain products, later versions will support fields specific to particular products, such as steel, based on the [steel accounting guidance](https://github.com/rmi/steel-guidance) created by RMI.

![ScreenShot](supnet_screenshot.png)

## Running it

This repo runs four containers, two postgres DBs, and two rails app--independed apps running the same code base, built and launched by docker-compose.yml. This is to allow demonstration of PACT-format files being shared between buyer and seller, if you simply want to run your own instance of the app, you can run the Dockerfile by itself. To run the whole thing:

1. Install Docker

2. Edit your /etc/hosts file so you can more easily connect to each app. Change the line `127.0.0.1       localhost` to `127.0.0.1       localhost buyer seller`

3. Clone this repo
```
git clone https://github.com/rmi/pcfer.git
```

4. cd into repo and build images. The app was originally name supnet and the Rails app retains that name; until that gets changed (soon) the volume needs to retain it.

```
cd pcfer
docker build -t pcfer-toolbox -f Dockerfile.rails .

docker volume create --name seller-postgres
docker volume create --name buyer-postgres
docker volume create --name supnet
```

5. Initialize:

```
docker compose up --build
```

6. Connect to the shell running in the container. In a separate terminal run `docker ps` to list running containers, then, using the container name you just found, connect to it:

```
docker ps
```

which will probably return, in the NAMES column, the values `pcfer-seller-pcfer-1` and `pcfer-buyer-pcfer-1`. Instert those, or the equivalent values from your system, like this, to shell into each container:

```
docker exec -t -i pcfer-seller-pcfer-1 /bin/bash
docker exec -t -i pcfer-buyer-pcfer-1 /bin/bash
```

7. After building for the first time you'll see you need to create the databases. In a separate terminal run:

```
docker compose run seller-pcfer rails db:create
docker compose run seller-pcfer rails db:migrate
```

and

```
docker compose run buyer-pcfer rails db:migrate
docker compose run buyer-pcfer rails db:create
```

8. Once the database is set up, you can start the containers normally:

```
docker compose up
```

You should then be able to hit it at both http://seller:3030/ and http://buyer:3000/, and experiment locally with how buyers and sellers interact and exchange PCFs.

Once set up, you can run `docker compose up` any time you want to start the app+db containers.

## Connecting to the database
`psql --host=localhost --username=pcfer --port=6544 --dbname=supnet`

buyer's db port is 6544, seller's is 6543 (mapped in both cases to the standard postgresql on the container side)

## CURL
To send PCF data via command line. The API key should be the one supplied by the Vendor.

`curl -v -H 'Content-Type: application/json' -H 'X-API-Key: sk_J8HcZp4OJxS3Rq4EdwVGdg' -d "@test_pact.json" -X POST http://localhost:3000/products.json`

## Using in other environments
This is not production software, and per the license is provide as-is with no warranty. If you want to set up a single instance of the app without the databases, use the Dockerfile by itself and either edit docker-compose.yml, or deploy the app container by other means.

## Sources

Portions of the docker setup were taken from:
https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

## License
Copyright (c) 2023 John McGrath (jmcgrath@rmi.org) and [RMI](https://rmi.org). See [LICENSE][] for
details.

[license]: LICENSE.md
