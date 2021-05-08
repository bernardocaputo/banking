defmodule Banking.BankAccountsFixtures do
  @moduledoc false

  alias Banking.AccountsFixtures
  alias Banking.ATM.BankAccount
  alias Banking.Repo

  defp default_balance, do: 50

  def valid_bank_account_attributes(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    Enum.into(attrs, %{
      balance: default_balance(),
      user_id: user.id
    })
  end

  def bank_account_fixture(attrs \\ %{}) do
    {:ok, bank_account} =
      attrs
      |> valid_bank_account_attributes()
      |> BankAccount.create_changeset()
      |> Repo.insert()

    bank_account
  end
end
