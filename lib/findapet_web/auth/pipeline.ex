defmodule FindapetWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :findapet

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
