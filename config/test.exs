import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :url_shortener, UrlShortenerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "dBBch+3B0229jXmv+aCXf13pyc90Q6EJL9Ba6iJS3o9UqL6GC4xUju0oNZCW1Eww",
  server: false

# In test we don't send emails.
config :url_shortener, UrlShortener.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
