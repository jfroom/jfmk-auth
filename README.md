# JFMK-Auth [![Build Status](https://travis-ci.org/jfroom/jfmk-auth.svg?branch=master)](https://travis-ci.org/jfroom/jfmk-auth)

Rails personal project with user management & authentication to proxy serve a private, single-page app.

## Technologies

- Rails 5, Postgres, Selenium, AWS S3, HAML, CoffeeScript, Bootstrap, SCSS 
- Docker Compose for development & test; Travis for CI/CD; [Heroku Pipelines](https://devcenter.heroku.com/articles/pipelines) for production
- 'Simple' [`has_secure_password`](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html) Rails API for authentication & cookie sessions. User is locked out after X failed attempts.
- Authenticated users are served single-page app with a proxied index page, and expiring pre-signed URLs for sensitive S3 hosted content are parsed/injected. Demo content is instance of [`jfroom/portfolio-web`](//github.com/jfroom/portfolio-web).
- 'Auto-login' feature can be enabled for a user, which creates a simple and aesthetic url: https://example.com/username. Be aware that using this lowers security threshold. Can implement [`has_secure_token`](http://api.rubyonrails.org/classes/ActiveRecord/SecureToken/ClassMethods.html) in future if this becomes a concern.
- Tests with MiniTest for models & integration, and Capybara Selenium acceptance tests running in a docker service with Chrome standalone.
- VNC locally into the Selenium session to interact and debug.
- Let's Encrypt SSL certificates auto bound to the custom Heroku domain with [`letsencrypt-rails-heroku`](https://github.com/pixielabs/letsencrypt-rails-heroku).
- Notify admin by email when user has logged in; sent with [SES](https://aws.amazon.com/ses/)
- Mailer job runs async in background job with [Sucker Punch](https://github.com/brandonhilkert/sucker_punch) 
- Project initially seeded with [`nickjj/orats`](//github.com/nickjj/orats) Rails template which was very helpful figuring out the `docker-compose` setup.
- [HoundCI](https://houndci.com) & [Rubocop](https://github.com/bbatsov/rubocop) help keep styles consistent

## Demo

https://jfmk-auth-demo.herokuapp.com

Credentials:<br/>
- admin:Admin123<br/>
- user:User123<br/>

Note:
- In demo mode, new users will not be saved, and existing users will not be updated, or deleted. Users will also not be locked out after repeat fails. This is done in order to keep the users active for future visitors to demo, and to prevent system abuse.
- Demo instance runs on a 'free' dyno server so it is probably sleeping, and may be a little sluggish starting up.

# Getting started

## Required

1. Install [Docker](https://www.docker.com/) 17.03.0-ce+. This should also install Docker Compose 1.11.2+.
2. Verify versions: `docker -v; docker-compose -v;`

## Recommended
1. Install some docker-compose aliases. I use [`docker-compose.plugin.zsh`](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/docker-compose/docker-compose.plugin.zsh) for oh-my-zsh. (Ex. `alias dcup='docker-compose up`)
2. Install [pgAdmin](https://www.pgadmin.org/download/) for a SQL gui client. 
3. Install [VNC Viewer](https://www.realvnc.com/download/viewer/) to view & interact with selenium sessions that would otherwise be headless.

# Build

## First run

`docker-compose up --build` Build the docker images, install dependencies, and start the services. 

Once the docker services are build and running, the web service will occupy the current terminal with the running puma server log. Open a new terminal instance to issue any additional commands. 

`docker-compose exec web rails db:setup` Set up the database.

`docker-compose exec web rails db:seed` Seed the database with two users: `admin:Admin123` and `user:User123`. Use the admin login to change those immediately.

## Development 

`docker-compose up` Stand up all services. Also installs any new gems if necessary (after switching branches, or pulling from a repo).

`open http://localhost:3000/` Visit the web app service.

`docker-compose exec web bin/update` Install a new gem, or to run a database migration.

`docker-compose down; docker-compose up -d; docker attach jfmkauth_web_1`
A common call chain during development to stop any existing/hung containers, stand up all services in detached mode, connect to view web service only (to view running log and interact with byebug). Be aware 'exec' bypasses the entrypoint script which ensures gems are up to date (use `docker-compose run --rm ...` instead of `docker-compose exec ...` if that is a concern - had to do this for the CI override file).

`docker-compose build` If there are changes to the `Dockerfile` or the `docker-compose` files, the containers may need to be rebuilt.

These [docker shortcuts](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes) to clean up old docker images/containers/volumes is very handy.

## Database

- Launch [pgAdmin](https://www.pgadmin.org/download/) and configure a connection to:
`Host: 0.0.0.0`, `Port: 5432`, `User: jfmk_auth`, `Password: yourpassword`. 
- Quick tip: To find User table with the seed users: Schemas > Public > Tables, or use the SQL panel.

## Test

`docker-compose exec web rails test` Run tests (also importantly sets Rails.env = 'test').

`vnc://localhost:5900 password:secret` To interactive with and debug Selenium sessions, use VNC to connect to the Selenium service. [VNC Viewer](https://www.realvnc.com/download/viewer/) works well, and on OS X Screen Sharing app is built-in.

To visit the test app on local machine: `open http://localhost:3001/`. To visit in the VNC session visit: `http://web:3001`. 

Commits to master are automatically tested by [Travis CI](https://travis-ci.org/jfroom/jfmk-auth). 

Tests use: 
- [`railsware/rack_session_access`](//github.com/railsware/rack_session_access) with Capybara to conveniently bypass session authenticating which speeds tests up.
- [`thoughtbot/climate_control`](//github.com/thoughtbot/climate_control) to adjust ENV vars for models/integration, and a custom `/test/backdoor/` route for the capybara test environment only to adjust ENV.


## Deploy

### Environment
Deploys to a [Heroku pipeline](https://devcenter.heroku.com/articles/pipelines) with three different apps: staging, demo and production. Currently, releases are infrequent, so just using the Heroku Pipelines GUI to promote staging to demo & prod. 

Ultimately would prefer to [deploy a Docker image to Heroku](https://devcenter.heroku.com/articles/container-registry-and-runtime) — but currently that features is in beta and [support for pipelines is spotty](https://devcenter.heroku.com/articles/container-registry-and-runtime#known-issues-and-limitations).

So for now, Docker and Heroku environments are aligned as closely as possible. Biggest exception being the Dockerfile runs [Debian Jessie](https://github.com/docker-library/ruby/blob/aba4590582d91d49926558ac27b9f005c7488bc9/2.3/slim/Dockerfile#L1), and Heroku uses [Cedar-14](https://devcenter.heroku.com/articles/stack#cedar) (Ubuntu 14.04 trusty).

### Manual
1. Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli).
2. Use [Rails 5 Getting Started guide](https://devcenter.heroku.com/articles/getting-started-with-rails5) for first deployment.
3. `source bin/deploy.sh` for iterative deploys.

### Continuous Deployment
If the Travis build passes, it will automatically deploy to staging. See [.travis.yml](.travis.yml). 

### SSL

On the production app's custom domain, [Let's Encrypt](https://letsencrypt.org/) handles the free SSL certificate with Pixielab's [`pixielabs/letsencrypt-rails-heroku`](https://github.com/pixielabs/letsencrypt-rails-heroku) gem.

Certificate is good for 90 days. To renew, run or schedule a variation of `heroku run -a jfmk-auth rake letsencrypt:renew`.

# Noteworthy

## Docker's Bundler Cache

[Bundler](http://bundler.io/) installs and keeps track of all the gem libraries. Keeping docker container build times low is not trivial when bundler is involved. It took some time & research to optimize bundler's cache, so is worth an explanation. Credit to the unboxed team for this [bundler cache technique](https://unboxed.co/blog/docker-re-bundling/).

The `web` service uses the `Dockerfile` to build itself. It defines an `ENTRYPOINT ["/docker-entrypoint.sh"]` bash script which will run the initial `bundle install`. Gems are stored in a docker volume called `bundle_cache` (see `docker-compose.yml`). When any gems are added to the `Gemfile`, this entrypoint script will notice and install them into the cache volume. Because of the entrypoint, there is no need to call a special command to do this other than `docker-compose up`. This technique is unique because the cache volume will persist across docker image changes, which reduces build times (and increases sanity) during local development. 

## Alternatives and Caveats

- __[S3Auth.com](http://s3auth.com)__ If you want a quick way to just password protect a static S3 website with Basic HTTP Auth, check out [S3Auth](https://github.com/yegor256/s3auth), and this related [article](http://www.yegor256.com/2014/04/21/s3-http-basic-auth.html).
- __S3 auth proxy.__ There are a few other project that handle [S3 proxy with authentication](https://www.google.com/search?q=s3+proxy+auth). But one drawback is the app server becomes a bottleneck — which becomes more obvious for large files like video. A mix of pre-signed S3 expiring private content URLs, and publicly served S3 non-sensitive files (e.g. JS, CSS, some content) alleviates this. Admittedly, the proxy/injection I've cooked up is a little brittle — which leads to my next point.
- __Simple content views.__ `app/controllers/proxy_controller` which parses/proxies/pre-signs S3 content is tightly coupled to my personal needs. If you choose to clone/fork this project for the user management aspect, you'll probably want to yank that controller, related tests, and environment vars. You could just replace it with simple HTML/HAML views.
- __Devise.__ In future projects I will use [Devise](https://github.com/plataformatec/devise) for authentication. Just wanted to write my own first to better understand the auth and user management process. 

# License
Copyright © JFMK, LLC Released under the [MIT License](https://github.com/jfroom/jfmk-auth/blob/master/LICENSE).
