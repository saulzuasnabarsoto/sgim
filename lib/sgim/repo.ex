defmodule Sgim.Repo do
  use Ecto.Repo,
    otp_app: :sgim,
    adapter: MssqlEcto
end
