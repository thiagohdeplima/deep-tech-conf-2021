FROM elixir:1.11-alpine

ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

WORKDIR /srv/app

COPY . .

RUN apk --no-cache --update add \
      make \
      g++ \
      wget \
      curl \
      inotify-tools \
      nodejs \
      socat \
      nodejs-npm
      
RUN npm install npm -g --no-progress

RUN update-ca-certificates --fresh

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get \
    && mix deps.compile \
    && mix compile

ENTRYPOINT [ "sh" ]

CMD ["-c", "socat TCP-LISTEN:8080,fork TCP:keycloak:8080 & mix deps.get && mix phx.server"]
