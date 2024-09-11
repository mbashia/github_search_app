defmodule GithubSearchAppWeb.SearchLiveTest do
  @moduledoc false
  use GithubSearchAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mox

  describe("Search Form ") do
    test "form renders correctly", %{conn: conn} do
      {:ok, live_view, html} = live(conn, ~p"/search")

      assert html =~ "devfinder"
      assert html =~ "The Octocat"

      assert html =~ "This profile has no bio"

      assert html =~ "Joined 25 Jan 2011"

      assert live_view
             |> element("#search-button", "Search")
             |> has_element?()

      assert has_element?(live_view, ~s(input[placeholder*="Search GitHub username…"]))
    end
  end

  test "searching for a user", %{conn: conn} do
    test_user = default_user()

    ApiClientBehaviourMock
    |> expect(:search_github, fn "octocat" -> {:ok, test_user} end)

    {:ok, live_view, _html} = live(conn, ~p"/search")

    live_view
    |> form("#search-form", %{"search" => "octocat"})
    |> render_submit()

    assert render(live_view) =~ test_user.name
    assert render(live_view) =~ test_user.location
  end

  def default_user() do
    %GithubSearchApp.UserProfile{
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
  end
end
