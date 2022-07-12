defmodule Findapet.Pets.Delete do
  alias Findapet.{Error, Pet, PetImageUploader, Repo}

  def call(id) do
    case Repo.get(Pet, id) do
      nil -> {:error, Error.pet_not_found_error()}
      pet -> delete_pet(pet)
    end
  end

  defp delete_pet(pet) do
    with {:ok, %Pet{avatar: avatar}} = result <- Repo.delete(pet),
         :ok <- PetImageUploader.delete({avatar, "uploads"}) do
      result
    end
  end
end
