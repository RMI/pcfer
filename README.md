# README

## Intro

PACTifier is a demo app to handle supply-chain PCF requests in an automated, machine-readable way. It lets you both create digital PCF files, and connect to other supnet nodes to get PCFs, or to incorporate their data into your own PCFs and improve them.

The demo uses the [PACT format for product-level greenhouse gas emissions](https://wbcsd.github.io/data-exchange-protocol/v2/), created by the WBCSD's Pathfinder Network. Using this data standard allows for interoperabity between independent nodes in a more fully-realized implementation of this idea.

This basic demo is for generic supply chain products, later versions may support fields specific to particular products.

![ScreenShot](supnet_screenshot.png)

## Running it

This repo runs four containers, two postgres DB, two a rails app. To run:

1. Install Docker

1. Clone this repo

```
git clone https://github.com/john/supnet.git
```

1. cd into repo and build images:

```
cd supnet
docker build -t pactifier-toolbox -f Dockerfile.rails .

docker volume create --name seller-postgres
docker volume create --name buyer-postgres
docker volume create --name supnet
```

1. Initialize:

```
docker compose up --build
```

1. Connect to the shell running in the container. First run `docker ps` to list running containers, then, using the container name you just found, connect to it:

```
docker ps
docker exec -t -i supnet-supnet-1 /bin/bash

or

docker exec -t -i supnet-seller-pactifier-1 /bin/bash
docker exec -t -i supnet-buyer-pactifier-1 /bin/bash
```

1. After building for the first time you'll see you need to create the databases. ctl-c, then run:

```
docker compose run supnet rails db:create
docker compose run supnet rails db:migrate
```

1. Once the database is set up, you can start the containers normally:

```
docker compose up
```

You should then be able to hit it at http://localhost:3000, and just run `docker compose up` any time you want to start the app+db container

### Connecting to the database

psql --host=localhost --username=supnet --port=6543 --dbname=supnet_development

### CURL
To send PCF data via command line. The API key should be the one supplied by the Vendor.

`curl -v -H 'Content-Type: application/json' -H 'X-API-Key: sk_J8HcZp4OJxS3Rq4EdwVGdg' -d "@test_pact.json" -X POST http://localhost:3000/products.json`

### Source

A lot of the docker parts were taken from:
https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

# TODO

- Add GenericProduct via generator
rails generate scaffold account name:string
rails g scaffold campaign name:string account:belongs_to

rails g scaffold GenericProduct name:string description:text cpc_code:string
# then add a generic_product_id field to Product and a Product belongs_to GenericProduct

Or maybe there's no need for this, if items can be grouped under CPC code? Do it later


- Associate Products to GenericProducts
- Update the Product form with a dropdown to associate them with a GenericProduct at time of creation
- Dropdown should be pre-populable by querystring so links sent to vendors work as expected

- Add Vendor via generator
rails g scaffold vendor name:string email:string description:text api_endpoint:string api_key:string



rails g scaffold customer name:string email:string description:text api_endpoint:string api_key:string



- Associate GenericProducts to Vendors
- Associate

- Add export to CSV
- Add uploader to create via CSV (invert the output of CSV export, make robust--postelize)
- URN fields need to convert to sets
- Add info mouseover explaining fields
- Simplified view to show only required and most common fields
- Add node selector for product requests to ingest outside data

- Instead of or complementary to nodes, allow for objects representing 'suppliers' and 'customers'--essentially upstream and downstream nodes. Then add the ability to accelpt PCFs from suppliers, with some kind of identifying/auth process that lets you email a confirmation request to an email at that company's domain. That sends them a one-time-use link to a form on the app, which lets them enter the API endpoint. When they do that they're provided an API key for the app (and this is where the upstream supplier/node object is created). Then when they send PCFs the system confirms it came from thei endpoint they specified, using the provided key, and records both the PCF, and the API it received it from.

For customers a similar process holds--they're emailed a one-time-use link, where they enter the URL the PCF will be sent *to*, and any key needed. Then they get access to a URL they can go to to request a PCF whenever they want one--they hit the button, and it's sent to the API. That URL also gives them the option to download a CSV.

Q:
- Should the supplier flow also provide them a URL where they can upload PCFs in CSV? Of course it should.