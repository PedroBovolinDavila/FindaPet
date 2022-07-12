defmodule Findapet.Repo do
  use Ecto.Repo,
    otp_app: :findapet,
    adapter: Ecto.Adapters.Postgres
end
