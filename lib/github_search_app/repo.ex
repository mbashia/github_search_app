defmodule GithubSearchApp.Repo do
  use Ecto.Repo,
    otp_app: :github_search_app,
    adapter: Ecto.Adapters.MyXQL
end
