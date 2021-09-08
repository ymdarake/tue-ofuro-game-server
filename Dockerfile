FROM elixir:1.12-alpine

WORKDIR /app
COPY . .
RUN mix local.hex --force && \
	mix local.rebar --force && \
	mix deps.get && \
	mix compile

CMD ["mix", "run", "--no-halt"]

