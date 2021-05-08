defmodule Banking.Accounts.User do
  @moduledoc """
  This module contain Users changeset and schema
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Banking.ATM.BankAccount

  @type t :: %__MODULE__{username: String.t(), password_hash: String.t()}

  schema "users" do
    field(:username, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    has_one(:bank_account, BankAccount)

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:username, min: 4, max: 20)
    |> validate_length(:password, min: 4, max: 20)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
