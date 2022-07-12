defmodule Findapet.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Findapet.Pet

  @create_params [:name, :email, :password, :cpf, :avatar, :age, :phone_number]
  @update_params [:name, :email, :cpf, :avatar, :age, :phone_number, :is_admin]

  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Jason.Encoder, only: @update_params ++ [:id]}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :cpf, :string
    field :avatar, :string
    field :phone_number, :string
    field :age, :integer
    field :is_admin, :boolean

    has_many :pets, Pet

    timestamps()
  end

  def changeset(params), do: changes(%__MODULE__{}, @create_params, params)
  def changeset(struct, params), do: changes(struct, @update_params, params)

  defp changes(struct, fields, params) do
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_length(:phone_number, greater_than: 10)
    |> validate_length(:cpf, is: 11)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> unique_constraint([:email])
    |> unique_constraint([:cpf])
    |> unique_constraint([:phone_number])
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
