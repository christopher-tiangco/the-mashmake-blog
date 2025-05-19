ARG RUBY_VERSION=3.3.4
ARG BASE_SRC=base-${RUBY_VERSION}

# Base stage with shared configuration and dependencies
FROM ruby:${RUBY_VERSION}-slim AS base

ARG NODE_VERSION=14.21.3
ARG BUNDLER_VERSION=2.3.18

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    bash -lc "source ~/.bashrc && nvm install v${NODE_VERSION} && npm install -g yarn"

ENV PATH=/root/.nvm/versions/node/v${NODE_VERSION}/bin:$PATH

RUN gem install bundler -v $BUNDLER_VERSION
RUN gem install sass-rails
RUN gem uninstall rackup -aIx || true
RUN gem install rails -v 7.0
#===================================================================================================

FROM base AS udemy-alpha-blog

# The host default user is `pi` and has UID set to 1000. Therefore, bake the same user into the image
# and add to the `root` group
RUN useradd -m -u 1000 pi && usermod -aG root pi

# Make pi the owner of the following subdirectory so bundler can install gems and yarn can be executed
RUN chown -R pi:pi /usr/local/bundle
RUN chown -R pi:pi /root

USER pi
WORKDIR /home/app

EXPOSE 3000
#===================================================================================================
