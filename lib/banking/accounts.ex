defmodule Banking.Accounts do
  alias Banking.Accounts.User
  alias Banking.Repo

  @doc """
  Create user
  """
  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    attrs
    |> User.create_changeset()
    |> Repo.insert()
  end

  @doc """
  Get user or raise error
  """
  @spec get_user!(Integer.t()) :: User.t() | no_return()
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Fetch User
  """
  @spec get_user_by_username(String.t()) :: User.t() | nil
  def get_user_by_username(username), do: Repo.get_by(User, %{username: username})

  @doc """
  Authenticate user
  """
  @spec authenticate_user(String.t(), String.t()) :: {:ok, User.t()} | {:error, atom()}
  def authenticate_user(username, password) do
    username
    |> get_user_by_username()
    |> _authenticate_user(password)
  end

  defp _authenticate_user(user, _password) when is_nil(user) do
    Argon2.no_user_verify()
    {:error, :invalid_credentials}
  end

  defp _authenticate_user(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end
end
