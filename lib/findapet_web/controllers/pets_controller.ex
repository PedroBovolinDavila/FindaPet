defmodule FindapetWeb.PetsController do
  use FindapetWeb, :controller

  alias Findapet.Pet
  alias FindapetWeb.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    with {:ok, pets} <- Findapet.get_pets() do
      conn
      |> put_status(:ok)
      |> render("index.json", pets: pets)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Pet{} = pet} <- Findapet.get_pet_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", pet: pet)
    end
  end

  def get_by_user_id(conn, %{"id" => id}) do
    with {:ok, pets} <- Findapet.get_pet_by_user_id(id) do
      conn
      |> put_status(:ok)
      |> render("index.json", pets: pets)
    end
  end

  def create(conn = %{private: %{guardian_default_resource: user}}, params) do
    with {:ok, %Pet{} = pet} <- Findapet.create_pet(Map.merge(params, %{"user_id" => user.id})) do
      conn
      |> put_status(:created)
      |> render("create.json", pet: pet)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Pet{}} <- Findapet.delete_pet(id) do
      conn
      |> put_status(:no_content)
      |> text("")
    end
  end
end
