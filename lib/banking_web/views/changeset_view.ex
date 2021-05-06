defmodule BankingWeb.ChangesetView do
  @moduledoc """
  Translates Changeset errors to readable json view
  """
  use BankingWeb, :view

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end
end
