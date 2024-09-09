defmodule GithubSearchAppWeb.SearchLiveTest do
  @moduledoc false
  use GithubSearchAppWeb.ConnCase

  import Phoenix.LiveViewTest

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
end
