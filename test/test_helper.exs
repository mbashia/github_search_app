ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(GithubSearchApp.Repo, :manual)
Mox.defmock(ApiClientBehaviourMock, for: GithubSearchApp.GithubClientBehaviour)
