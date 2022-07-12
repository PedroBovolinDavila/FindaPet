defmodule Findapet.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Findapet.User

  @required_params [:name, :age, :description, :avatar, :type, :user_id]

  @derive {Jason.Encoder, only: @required_params ++ [:id, :user]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "pets" do
    field :name, :string
    field :age, :integer
    field :description, :string
    field :avatar, :string
    field :type, :string

    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:description, min: 10)
    |> validate_number(:age, greater_than_or_equal_to: 0)
  end
end
