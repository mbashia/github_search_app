defmodule GithubSearchApp.GithubClientTests do
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  @valid_response %GithubSearchApp.UserProfile{
    avatar_url: "https://avatars.githubusercontent.com/u/96841734?v=4",
    bio: "SOFTWARE ENGINEER!!",
    blog: "https://www.mbashia.com",
    company: "Mbashia Tech",
    created_at: "2021-12-29T18:54:05Z",
    email: nil,
    followers: 18,
    following: 47,
    location: "Nairobi,Kenya",
    login: "mbashia",
    name: "mbashia",
    public_repos: 67,
    twitter_username: "VMbashia",
    profile_url: "https://github.com/mbashia"
  }
  def api_client, do: Application.get_env(:github_search_app, :api_client)

  def search_github(username) do
    api_client().search_github(username)
  end

  describe "get user search" do
    test "passing valid username returns  existing user" do
      ApiClientBehaviourMock
      |> expect(:search_github, fn "mbashia" ->
        {:ok, @valid_response}
      end)

      assert {:ok, @valid_response} =
               search_github("mbashia")
    end

    test "returns error when user does not exist" do
      ApiClientBehaviourMock
      |> expect(:search_github, fn "mbashiazzzzzzzzzz" ->
        {:error, "Not found"}
      end)

      assert {:error, "Not found"} =
               search_github("mbashiazzzzzzzzzz")
    end
  end
end
