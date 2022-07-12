# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :findapet,
  ecto_repos: [Findapet.Repo]

config :findapet, Findapet.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :findapet, FindapetWeb.Auth.Guardian,
  issuer: "findapet",
  secret_key: "aO4V6+XpSPWGop1sjPRczBECE/gW4hWMhgJzamA+q/JzaF6zOoED3czcWGiK9ajW"

config :findapet, FindapetWeb.Auth.Pipeline,
  module: FindapetWeb.Auth.Guardian,
  error_handler: FindapetWeb.Auth.ErrorHandler

config :arc,
  storage: Arc.Storage.Local,
  storage_dir: "uploads"

# Configures the endpoint
config :findapet, FindapetWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FindapetWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Findapet.PubSub,
  live_view: [signing_salt: "keBYO0+Q"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
