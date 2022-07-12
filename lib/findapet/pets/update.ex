defmodule Findapet.Pets.Update do
  alias Ecto.UUID
  alias Findapet.{Error, Pet, PetImageUploader, Repo}

  def call(%{"id" => id, "image" => image} = params) do
    original_name = image.filename
    image = %{image | filename: "pet-#{UUID.generate()}-#{original_name}"}

    with pet <- Repo.get(Pet, id),
         :ok <- PetImageUploader.delete({pet.avatar, "uploads"}),
         {:ok, %Pet{}} = result <- update_pet(pet, params, image),
         {:ok, _filename} <- PetImageUploader.store({image, "uploads"}) do
      result
    else
      nil -> {:error, Error.pet_not_found_error()}
      {:error, changeset} -> {:error, Error.build(:bad_request, changeset)}
      _ -> {:error, Error.build(:bad_request, "Error on image uploading!")}
    end
  end

  def call(%{"id" => id} = params) do
    with pet <- Repo.get(Pet, id),
         {:ok, %Pet{}} = result <- update_pet(pet, params) do
      result
    else
      nil -> {:error, Error.pet_not_found_error()}
      {:error, changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  defp update_pet(pet, params, %{filename: filename}) do
    pet
    |> Pet.changeset(%{params | "avatar" => filename})
    |> Repo.insert()
  end

  defp update_pet(pet, params) do
    pet
    |> Pet.changeset(params)
    |> Repo.update()
    |> handle_update()
  end

  defp handle_update({:ok, %Pet{} = pet}), do: {:ok, Repo.preload(pet, :user)}
  defp handle_update({:error, _changeset} = result), do: result
end
