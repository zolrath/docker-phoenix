FROM elixir:1.8.1
MAINTAINER Nicolas Bettenburg <nicbet@gmail.com>

RUN mix local.hex --force \
 && apt-get update \
 && curl -sL https://deb.nodesource.com/setup_10.x | bash \
 && apt-get install -y apt-utils \
 && apt-get install -y nodejs \
 && apt-get install -y build-essential \
 && apt-get install -y inotify-tools \
 && apt-get install -y git \
 && mix local.rebar --force

WORKDIR /tmp
RUN git clone https://github.com/phoenixframework/phoenix.git \
 && cd phoenix \
 && mix deps.get \
 && cd installer \
 && mix deps.get \
 && MIX_ENV=prod mix do archive.build, archive.install --force

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

EXPOSE 4000

CMD ["mix", "phx.server"]
