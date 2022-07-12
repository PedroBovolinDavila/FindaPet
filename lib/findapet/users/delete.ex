defmodule Findapet.Users.Delete do
  alias Findapet.{AvatarUploader, Error, Repo, User}

  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.user_not_found_error()}
      user -> delete_user(user)
    end
  end

  defp delete_user(user) do
    with {:ok, %User{avatar: avatar}} = result <- Repo.delete(user),
         :ok <- AvatarUploader.delete({avatar, "uploads"}) do
      result
    end
  end
end
