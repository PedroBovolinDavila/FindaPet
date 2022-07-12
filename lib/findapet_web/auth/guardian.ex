defmodule FindapetWeb.Auth.Guardian do
  use Guardian, otp_app: :findapet

  alias Findapet.{Error, User}

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, id}
  end

  def resource_from_claims(%{"sub" => id}) do
    Findapet.get_user_by_id(id)
  end

  def authenticate(%{"email" => email, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- Findapet.get_user_by_email(email),
         true <- Pbkdf2.verify_pass(password, hash),
         {:ok, token, _claims} <- encode_and_sign(user) do
      {:ok, token}
    else
      _ -> {:error, Error.build(:unauthorized, "Email or passoword incorrect!")}
    end
  end

  def authenticate(_), do: {:error, Error.build(:bad_request, "Email or passoword missing!")}
end
