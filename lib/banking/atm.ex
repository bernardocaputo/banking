defmodule Banking.ATM do
  @moduledoc """
  This module handle the ATM machine context where you can check
   your balance, deposit or withdrawal from your bank account
  """
  alias Banking.Accounts.User
  alias Banking.ATM.BankAccount
  alias Banking.Repo
  alias Ecto.Multi

  @doc """
  Create Bank Account
  """
  @spec create_bank_account(User.t()) :: {:ok, BankAccount.t()} | {:error, Ecto.Changeset.t()}
  def create_bank_account(user) do
    %{user_id: user.id}
    |> BankAccount.create_changeset()
    |> Repo.insert()
  end

  @doc """
  Return balance from bank account
  """
  @spec show_bank_account(integer()) :: {:ok, BankAccount.t()} | {:error, atom()}
  def show_bank_account(user_id) do
    case Repo.get_by(BankAccount, %{user_id: user_id}) do
      nil -> {:error, :bank_account_not_found}
      bank_account -> {:ok, bank_account}
    end
  end

  @doc """
  Deposit the given amount to bank account
  """
  @spec deposit_to(BankAccount.t(), pos_integer()) ::
          {:ok, BankAccount.t()} | {:error, Ecto.Changeset.t()}
  def deposit_to(bank_account, deposit_amount)
      when is_integer(deposit_amount) and deposit_amount > 0 do
    bank_account
    |> BankAccount.deposit_changeset(deposit_amount)
    |> proccess_transaction()
  end

  def deposit_to(_bank_account, invalid_deposit_amount)
      when not is_integer(invalid_deposit_amount),
      do: {:error, :invalid_deposit_amount}

  def deposit_to(_bank_account, non_pos_integer)
      when is_integer(non_pos_integer) and non_pos_integer <= 0,
      do: {:error, :must_be_greater_than_0}

  @doc """
  Withdrawal the given amount from bank account
  """
  @spec withdrawal_from(BankAccount.t(), pos_integer()) ::
          {:ok, BankAccount.t()} | {:error, Ecto.Changeset.t()}
  def withdrawal_from(bank_account, withdrawal_amount)
      when is_integer(withdrawal_amount) and withdrawal_amount > 0 do
    bank_account
    |> BankAccount.withdrawal_changeset(withdrawal_amount)
    |> proccess_transaction()
  end

  def withdrawal_from(_bank_account, invalid_withdrawal_amount)
      when not is_integer(invalid_withdrawal_amount),
      do: {:error, :invalid_withdrawal_amount}

  def withdrawal_from(_bank_account, non_pos_integer)
      when is_integer(non_pos_integer) and non_pos_integer <= 0,
      do: {:error, :must_be_greater_than_0}

  defp proccess_transaction(changeset) do
    Multi.new()
    |> Multi.update(:bank_account, changeset)
    |> Repo.transaction()
    |> case do
      {:ok, %{bank_account: bank_account}} -> {:ok, bank_account}
      {:error, _operation, changeset, _changes} -> {:error, changeset}
    end
  end
end
