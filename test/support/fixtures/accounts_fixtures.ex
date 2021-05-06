defmodule Banking.AccountsFixtures do
  alias Banking.Accounts.User
  alias Banking.Repo

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      username: "#{System.unique_integer()}",
      password: "123456"
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> User.create_changeset()
      |> Repo.insert()

    user
  end
end
