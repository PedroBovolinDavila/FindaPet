defmodule Findapet.Pets.Create do
  alias Ecto.{Changeset, UUID}
  alias Findapet.{Error, Pet, PetImageUploader, Repo}

  def call(%{"image" => image} = params) do
    original_name = image.filename
    image = %{image | filename: "pet-#{UUID.generate()}-#{original_name}"}

    with {:ok, %Pet{}} = result <- create_pet(params, image.filename),
         {:ok, _filename} <- PetImageUploader.store({image, "uploads"}) do
      result
    else
      {:error, %Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
      {:error, _reason} -> {:error, Error.build(:bad_request, "Error on pet image upload!")}
    end
  end

  defp create_pet(params, filename) do
    Map.merge(params, %{"avatar" => filename})
    |> Pet.changeset()
    |> Repo.insert()
    |> preload_user()
  end

  defp preload_user({:error, _changeset} = result), do: result

  defp preload_user({:ok, %Pet{} = pet}), do: {:ok, Repo.preload(pet, :user)}
end
