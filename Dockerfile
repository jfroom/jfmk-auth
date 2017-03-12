# https://github.com/nickjj/orats

FROM ruby:2.3-slim
# Docker images can start off with nothing, but it's extremely
# common to pull in from a base image. In our case we're pulling
# in from the slim version of the official Ruby 2.3 image.
#
# Details about this image can be found here:
# https://hub.docker.com/_/ruby/
#
# Slim is pulling in from the official Debian Jessie image.
#
# You can tell it's using Debian Jessie by clicking the
# Dockerfile link next to the 2.3-slim bullet on the Docker hub.
#
# The Docker hub is the standard place for you to find official
# Docker images. Think of it like GitHub but for Docker images.

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev git
# Ensure that our apt package list is updated and install a few
# packages to ensure that we can compile assets (nodejs),
# communicate with PostgreSQL (libpq-dev), bundle install from a git repo (git).

RUN gem uninstall -i /usr/local/lib/ruby/gems/2.3.0 bundler
RUN gem install bundler -v=1.13.7
RUN bundler -v
# Use same bundler version as Heroku (as of 2/2017)

ENV INSTALL_PATH /jfmk_auth
# The name of the application is jfmk_auth and while there
# is no standard on where your project should live inside of the Docker
# image, I like to put it in the root of the image and name it
# after the project.
#
# We don't even need to set the INSTALL_PATH variable, but I like
# to do it because we're going to be referencing it in a few spots
# later on in the Dockerfile.
#
# The variable could be named anything you want.

RUN mkdir -p $INSTALL_PATH
# This just creates the folder in the Docker image at the
# install path we defined above.

WORKDIR $INSTALL_PATH
# We're going to be executing a number of commands below, and
# having to CD into the /jfmk_auth folder every time would be
# lame, so instead we can set the WORKDIR to be /jfmk_auth.
#
# By doing this, Docker will be smart enough to execute all
# future commands from within this directory.

COPY . .
# This might look a bit alien but it's copying in everything from
# the current directory relative to the Dockerfile, over to the
# /jfmk_auth folder inside of the Docker image.
#
# We can get away with using the . for the second argument because
# this is how the unix command cp (copy) works. It stands for the
# current directory.

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
# Add bundle entry point to handle bundle cache
# https://unboxed.co/blog/docker-re-bundling/

ENV PATH="/bundle/bin:${PATH}"
RUN echo "$PATH"
# Bundle installs with binstubs to our custom /bundle/bin volume path. Let system use those stubs.
