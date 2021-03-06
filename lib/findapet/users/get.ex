defmodule Findapet.Users.Get do
  alias Findapet.{Error, Repo, User}

  def call, do: {:ok, Repo.all(User)}

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.user_not_found_error()}
      user -> {:ok, user}
    end
  end

  def by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, Error.user_not_found_error()}
      user -> {:ok, user}
    end
  end
end
