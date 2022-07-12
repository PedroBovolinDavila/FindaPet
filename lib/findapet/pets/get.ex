defmodule Findapet.Pets.Get do
  import Ecto.Query

  alias Findapet.{Error, Pet, Repo}

  def call do
    pets =
      Pet
      |> Repo.all()
      |> Repo.preload(:user)

    {:ok, pets}
  end

  def by_id(id) do
    Pet
    |> Repo.get(id)
    |> Repo.preload(:user)
    |> handle_get()
  end

  def by_user_id(id) do
    query = from pet in Pet, where: pet.user_id == ^id

    Repo.all(query)
    |> Repo.preload(:user)
    |> handle_get()
  end

  defp handle_get(nil), do: {:error, Error.pet_not_found_error()}
  defp handle_get(pet), do: {:ok, pet}
end
