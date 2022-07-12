defmodule FindapetWeb.EnsureIsAdmin do
  import Plug.Conn

  alias Findapet.User
  alias Plug.Conn

  def init(options), do: options

  def call(%Conn{private: %{guardian_default_resource: %User{} = user}} = conn, _options) do
    case user.is_admin do
      true -> conn
      false -> render_error(conn)
    end
  end

  defp render_error(conn) do
    body = Jason.encode!(%{message: "User is not a admin!"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, body)
    |> halt()
  end
end
