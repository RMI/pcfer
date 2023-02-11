# README

App based on this tutorial:
https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

This repo runs two containers, one a postgres db, the other a rails app. A Sidekiq queue runner and Redis instance to back it are also present in the configuration, but commented out.

1. Install Docker (https://docs.docker.com/desktop/install/mac-install/)

1. Build image:

`docker build -t supnet-toolbox -f Dockerfile.rails .`

1. To initialize:
docker compose up --build

1. After building for the first time you'll see need to create the databases. ctl-c, then run:

`docker compose run supnet rails db:create`

`docker compose run supnet rails db:create RAILS_ENV=test`

(not sure why I'm having to do this separately, I had thought dev and test both got created, for some reason that's not happening)

`docker compose run supnet rails db:migrate`
`docker compose run supnet rails db:migrate  RAILS_ENV=test`

Then start app thusly:
`docker compose up`

You should then be able to hit it at http://localhost:3000


# Need to totally start over?
Stop the container(s) using the following command:
docker-compose down

Delete all containers using the following command:
docker rm -f $(docker ps -a -q)

Delete all volumes using the following command:
docker volume rm $(docker volume ls -q)