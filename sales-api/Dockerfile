FROM elixir:1.11-alpine

ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

WORKDIR /srv/app

COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get \
    && mix deps.compile \
    && mix compile

ENTRYPOINT [ "sh" ]

CMD ["-c", "mix deps.get && mix ecto.setup && mix phx.server"]
