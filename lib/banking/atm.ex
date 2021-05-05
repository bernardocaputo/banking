defmodule Banking.ATM do
  alias Banking.ATM.BankAccount

  @doc """
  Return balance from bank account
  """
  @spec check_balance(BankAccount.t()) :: non_neg_integer()
  def check_balance(bank_account) do
    Map.get(bank_account, :balance)
  end
end
