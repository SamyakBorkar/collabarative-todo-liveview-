defmodule CollaberativeTodo.Repo do
  use Ecto.Repo,
    otp_app: :collaberative_todo,
    adapter: Ecto.Adapters.Postgres
end
