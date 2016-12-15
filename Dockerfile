FROM quay.io/nordstrom/ruby:2.3-1
MAINTAINER Nordstrom Kubernetes Platform Team "techk8s@nordstrom.com"

ARG PORTUS_VERSION=2.1.1

USER root

RUN apt-get update -qy \
 && apt-get install -qy \
      build-essential \
      libcurl4-openssl-dev \
      libmysqlclient-dev \
      nodejs \
      npm

RUN mkdir /portus \
 && chown ubuntu:ubuntu /portus \
 && gem update --system \
 && gem install --no-rdoc --no-ri \
      bundler

USER ubuntu

RUN curl -Lo /tmp/portus.tgz https://github.com/SUSE/Portus/archive/${PORTUS_VERSION}.tar.gz \
 && tar -xvzf /tmp/portus.tgz -C /portus --strip-components=1

WORKDIR /portus

RUN bundle install --verbose --retry=3 --no-cache --clean --path=/portus/.bundle

ENTRYPOINT ["bundle", "exec", "puma"]
CMD ["config.ru"]
