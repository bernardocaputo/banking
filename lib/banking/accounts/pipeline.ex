defmodule Banking.Accounts.Pipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :banking,
    error_handler: Banking.Accounts.ErrorHandler,
    module: Banking.Accounts.Guardian

  # If there is an authorization header, restrict it to an access token and validate it
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  # Load the user if either of the verifications worked
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
