defmodule BankingWeb.BankAccountView do
  @moduledoc false

  use BankingWeb, :view

  def render("show.json", %{bank_account: bank_account}) do
    %{
      data: render_one(bank_account, __MODULE__, "bank_account.json")
    }
  end

  def render("bank_account.json", %{bank_account: bank_account}) do
    %{
      balance: bank_account.balance
    }
  end
end
