defmodule FindapetWeb.UsersView do
  use FindapetWeb, :view

  alias Findapet.User

  def render("index.json", %{users: users}), do: %{users: users}

  def render("session.json", %{token: token}), do: %{token: token}

  def render("show.json", %{user: %User{} = user}), do: %{user: user}

  def render("create.json", %{user: %User{} = user}) do
    %{
      message: "User created!",
      user: user
    }
  end

  def render("update.json", %{user: %User{} = user}) do
    %{
      message: "User updated!",
      user: user
    }
  end
end
