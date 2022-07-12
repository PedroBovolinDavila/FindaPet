defmodule Findapet.Repo.Migrations.CreatePetsTable do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string
      add :age, :integer
      add :description, :string
      add :avatar, :string
      add :type, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end
  end
end
