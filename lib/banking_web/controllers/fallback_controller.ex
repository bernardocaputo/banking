defmodule BankingWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """

  use BankingWeb, :controller

  require Logger

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankingWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, error_msg}) when is_atom(error_msg) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      errors: %{
        message: error_msg |> Atom.to_string() |> String.replace("_", " ") |> String.capitalize()
      }
    })
  end

  def call(conn, err) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: %{message: inspect(err)}})
  end
end
