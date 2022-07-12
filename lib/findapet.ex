defmodule Findapet do
  alias Findapet.Users.Create, as: CreateUser
  alias Findapet.Users.Delete, as: DeleteUser
  alias Findapet.Users.Get, as: GetUser
  alias Findapet.Users.Update, as: UpdateUser
  alias Findapet.Users.UpdateAdmin, as: UpdateAdminUser

  alias Findapet.Pets.Create, as: CreatePet
  alias Findapet.Pets.Delete, as: DeletePet
  alias Findapet.Pets.Get, as: GetPet

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate update_user(params), to: UpdateUser, as: :call
  defdelegate update_user_admin(id), to: UpdateAdminUser, as: :call
  defdelegate delete_user(id), to: DeleteUser, as: :call
  defdelegate get_users(), to: GetUser, as: :call
  defdelegate get_user_by_id(id), to: GetUser, as: :by_id
  defdelegate get_user_by_email(email), to: GetUser, as: :by_email

  defdelegate create_pet(params), to: CreatePet, as: :call
  defdelegate delete_pet(id), to: DeletePet, as: :call
  defdelegate get_pets(), to: GetPet, as: :call
  defdelegate get_pet_by_id(id), to: GetPet, as: :by_id
  defdelegate get_pet_by_user_id(id), to: GetPet, as: :by_user_id
end
