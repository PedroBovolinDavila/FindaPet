defmodule Findapet.Error do
  @keys [:status, :message]

  @enforce_keys @keys

  defstruct @keys

  def build(status, message) do
    %__MODULE__{
      status: status,
      message: message
    }
  end

  def user_not_found_error, do: build(:not_found, "User not found!")
  def pet_not_found_error, do: build(:not_found, "Pet not found!")
end
