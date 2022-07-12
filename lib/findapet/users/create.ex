defmodule Findapet.Users.Create do
  alias Ecto.{Changeset, UUID}
  alias Findapet.{AvatarUploader, Error, Repo, User}

  def call(%{"avatar" => avatar} = params) do
    original_name = avatar.filename
    avatar = %{avatar | filename: "user-#{UUID.generate()}-#{original_name}"}

    with {:ok, %User{}} = result <- create_user(params, avatar.filename),
         {:ok, _filename} <- AvatarUploader.store({avatar, "uploads"}) do
      result
    else
      {:error, %Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
      {:error, _reason} -> {:error, Error.build(:bad_request, "Error on avatar upload!")}
    end
  end

  defp create_user(params, filename) do
    %{params | "avatar" => filename}
    |> User.changeset()
    |> Repo.insert()
  end
end
