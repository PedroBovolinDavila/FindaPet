defmodule FindapetWeb.UsersController do
  use FindapetWeb, :controller

  alias Findapet.User
  alias FindapetWeb.{Auth.Guardian, FallbackController}

  action_fallback FallbackController

  def index(conn, _params) do
    with {:ok, users} <- Findapet.get_users() do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Findapet.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def create(conn, params) do
    with {:ok, %User{} = user} <- Findapet.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def update(conn, params) do
    with {:ok, %User{} = user} <- Findapet.update_user(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{}} <- Findapet.delete_user(id) do
      conn
      |> put_status(:no_content)
      |> text("")
    end
  end

  def session(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("session.json", token: token)
    end
  end

  def update_admin(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Findapet.update_user_admin(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end
end
