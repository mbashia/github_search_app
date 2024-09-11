defmodule GithubSearchAppWeb.SearchLiveTest do
  @moduledoc false
  use GithubSearchAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mox

  describe("Search Form ") do
    test "form renders correctly", %{conn: conn} do
      {:ok, live_view, html} = live(conn, ~p"/search")

      assert html =~ "devfinder"
      assert html =~ "mbashia"

      assert html =~ "SOFTWARE ENGINEER!!"

      assert html =~ "Joined 29 Dec 2021"

      assert live_view
             |> element("#search-button", "Search")
             |> has_element?()

      assert has_element?(live_view, ~s(input[placeholder*="Search GitHub username…"]))
    end
  end

  test "searching for a user", %{conn: conn} do
    test_user = default_user()

    ApiClientBehaviourMock
    |> expect(:search_github, fn "mbashia" -> {:ok, test_user} end)

    {:ok, live_view, _html} = live(conn, ~p"/search")

    live_view
    |> form("#search-form", %{"search" => "mbashia"})
    |> render_submit()

    assert render(live_view) =~ test_user.name
    assert render(live_view) =~ test_user.location
  end

  def default_user() do
    %GithubSearchApp.UserProfile{
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
  end
end
