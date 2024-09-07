defmodule GithubSearchAppWeb.SearchLive.Index do
  use GithubSearchAppWeb, :live_view
  alias GithubSearchApp.GithubApi
  @impl true
  def mount(_params, _session, socket) do
    ## djdjdjd
    {:ok,
     socket
     |> assign(:user, default_user())
     |> assign(:title, "devfinder")
     |> assign_new(:form, fn ->
       to_form(%{})
     end)}
  end

  @impl true

  def handle_event("validate", %{"search" => search}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    IO.inspect(search)

    {:ok, searched_user} = GithubApi.search_github(search)

    {:noreply,
     socket
     |> assign(:user, searched_user)}
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

  def process_user_struct({:ok, struct}) do
    struct
    |> Map.from_struct()
    |> Enum.map(fn {key, value} ->
      {key, check_field(value)}
    end)
    |> Enum.into(%{})
    |> struct(GithubSearchApp.UserProfile)
  end

  defp format_date(date) do
    {:ok, utc_time, _int} = DateTime.from_iso8601(date)

    utc_time
    |> DateTime.to_date()
    |> Timex.format!("{D} {Mshort} {YYYY}")
  end

  defp check_field(nil), do: "Not filled"
  defp check_field(value), do: value
end
