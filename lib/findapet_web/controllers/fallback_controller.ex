defmodule FindapetWeb.FallbackController do
  use FindapetWeb, :controller

  alias Findapet.Error
  alias FindapetWeb.ErrorView

  def call(conn, {:error, %Error{status: status, message: message}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", message: message)
  end
end
