defmodule Findapet.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :cpf, :string
      add :avatar, :string
      add :phone_number, :string
      add :age, :integer
      add :is_admin, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:cpf])
    create unique_index(:users, [:phone_number])
  end
end
