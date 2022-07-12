defmodule Findapet.Users.UpdateAdmin do
  alias Findapet.{Error, Repo, User}

  def call(id) do
    with user <- Repo.get(User, id),
         {:ok, %User{}} = result <- update_admin(user) do
      result
    else
      nil -> {:error, Error.user_not_found_error()}
      {:error, changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  # TODO: Refazer o metodo usando !admin

  defp update_admin(%User{is_admin: false} = user) do
    user
    |> User.changeset(%{"is_admin" => true})
    |> Repo.update()
  end

  defp update_admin(%User{is_admin: true} = user) do
    user
    |> User.changeset(%{"is_admin" => false})
    |> Repo.update()
  end
end
