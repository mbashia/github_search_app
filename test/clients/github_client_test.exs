defmodule GithubSearchApp.GithubClientTests do
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  @valid_response %GithubSearchApp.UserProfile{
    avatar_url: "https://avatars.githubusercontent.com/u/583231?v=4",
    bio: nil,
    blog: "https://github.blog",
    company: "@github",
    created_at: "2011-01-25T18:44:36Z",
    email: nil,
    followers: 14878,
    following: 9,
    location: "San Francisco",
    login: "octocat",
    name: "The Octocat",
    public_repos: 8,
    twitter_username: nil,
    profile_url: "https://github.com/octocat"
 
  }
  def api_client, do: Application.get_env(:github_search_app, :api_client)

  def search_github(username) do
    api_client().search_github(username)
  end

  describe "get user search" do
    test "passing valid username returns  existing user" do
      ApiClientBehaviourMock
      |> expect(:search_github, fn "octocat" ->
        {:ok, @valid_response}
      end)

      assert {:ok, @valid_response} =
               search_github("octocat")
    end

    test "returns error when user does not exist" do
      ApiClientBehaviourMock
      |> expect(:search_github, fn "octocatzzzzzzzzzz" ->
        {:error, "Not found"}
      end)

      assert {:error, "Not found"} =
               search_github("octocatzzzzzzzzzz")
    end
  end
end
