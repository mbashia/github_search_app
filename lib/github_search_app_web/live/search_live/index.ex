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

  defp format_date(date) do
    {:ok, utc_time, _int} = DateTime.from_iso8601(date)

    utc_time
    |> DateTime.to_date()
    |> Timex.format!("{D} {Mshort} {YYYY}")
  end

  defp format_bio(bio) do
    bio
    |> case do
      nil -> "The Profile has no bio"
      bio -> bio
    end
  end

  defp format_field(field) do
    field
    |> case do
      nil -> "Not Available"
      field -> field
    end
  end
end
