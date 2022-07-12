defmodule FindapetWeb.PetsView do
  use FindapetWeb, :view

  alias Findapet.Pet

  def render("index.json", %{pets: pets}), do: %{pets: pets}

  def render("show.json", %{pet: %Pet{} = pet}), do: %{pet: pet}

  def render("create.json", %{pet: %Pet{} = pet}) do
    %{
      message: "Pet created!",
      pet: pet
    }
  end
end
