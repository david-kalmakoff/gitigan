defmodule Gitigan.Repo do
  use Ecto.Repo,
    otp_app: :gitigan,
    adapter: Ecto.Adapters.SQLite3
end
