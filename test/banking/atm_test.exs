defmodule Banking.ATMTest do
  use Banking.DataCase
  import Banking.BankAccountsFixtures
  alias Banking.ATM

  describe "check_balance/1" do
    test "return balance" do
      bank_account = bank_account_fixture()
      assert ATM.check_balance(bank_account) == bank_account.balance
    end
  end
end
