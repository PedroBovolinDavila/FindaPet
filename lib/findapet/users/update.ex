defmodule Findapet.Users.Update do
  alias Ecto.UUID
  alias Findapet.{AvatarUploader, Error, Repo, User}

  def call(%{"id" => id, "avatar" => avatar} = params) do
    original_name = avatar.filename
    avatar = %{avatar | filename: "#{UUID.generate()}-#{original_name}"}

    with user <- Repo.get(User, id),
         :ok <- AvatarUploader.delete({user.avatar, "uploads"}),
         {:ok, %User{}} = result <- update_user(user, avatar, params),
         {:ok, _filename} <- AvatarUploader.store({avatar, "uploads"}) do
      result
    else
      nil -> {:error, Error.user_not_found_error()}
      {:error, changeset} -> {:error, Error.build(:bad_request, changeset)}
      _ -> {:error, Error.build(:bad_request, "Error on avatar uploading!")}
    end
  end

  def call(%{"id" => id} = params) do
    with user <- Repo.get(User, id),
         {:ok, %User{}} = result <- update_user(user, params) do
      result
    else
      nil -> {:error, Error.user_not_found_error()}
      {:error, changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  defp update_user(user, %{filename: filename}, params) do
    user
    |> User.changeset(%{params | "avatar" => filename})
    |> Repo.update()
  end

  defp update_user(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end
end
