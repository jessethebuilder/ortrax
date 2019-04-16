FROM alpine:3.9
MAINTAINER Jesse Farmer <jesse@anysoft.us>

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base firefox-esr
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler

RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN apk --no-cache add \
    chromium-chromedriver\
    zlib-dev \
    chromium \
    xvfb \
    wait4ports \
    xorg-server \
    dbus \
    ttf-freefont \
    mesa-dri-swrast \
    udev

RUN mkdir /usr/app
WORKDIR /usr/app

COPY Gemfile /usr/app/
RUN bundle install

COPY . /usr/app
RUN mv /usr/app/bin/geckodriver /usr/local/bin

# RUN ruby /usr/app/test_all_cases.rb
