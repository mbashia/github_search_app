defmodule GithubSearchAppWeb.SearchLive.Index do
  use GithubSearchAppWeb, :live_view
  # alias GithubSearchApp.GithubApiClient
  @impl true
  def mount(_params, _session, socket) do
    ## djdjdjd
    {:ok,
     socket
     |> assign(:user, default_user())
     |> assign(:error, "")
     |> assign(:title, "devfinder")
     |> assign_new(:form, fn ->
       to_form(%{})
     end)}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    IO.inspect(search)

    case IO.inspect(api_client().search_github(search)) do
      {:ok, searched_user} ->
        {:noreply,
         socket
         |> assign(:user, searched_user)
         |> assign(:error, "")}

      {:info, info} ->
        {:noreply,
         socket
         |> assign(:user, default_user())
         |> assign(:info, info)}

      {:error, _error} ->
        {:noreply,
         socket
         |> assign(:user, default_user())
         |> assign(:error, "No results")}
    end
  end

  def api_client, do: Application.get_env(:github_search_app, :api_client)

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

  defp format_date(date) do
    {:ok, utc_time, _int} = DateTime.from_iso8601(date)

    utc_time
    |> DateTime.to_date()
    |> Timex.format!("{D} {Mshort} {YYYY}")
  end

  defp format_bio(bio) do
    bio
    |> case do
      nil -> "This profile has no bio"
      bio -> bio
    end
  end

  defp format_field(field) do
    IO.inspect(field, label: "field before editing")

    field
    |> case do
      nil -> "Not Available"
      "" -> "Not Available"
      field -> field
    end
  end
end
