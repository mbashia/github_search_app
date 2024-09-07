defmodule GithubSearchAppWeb.SearchLive.Index do
  use GithubSearchAppWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    ## djdjdjd
    {:ok,
     socket
     |> assign(:user, default_user())
     |> assign(:title, "dev finder")
     |> assign_new(:form, fn ->
       to_form(%{})
     end)}
  end

  @impl true

  def handle_event("validate", %{"search" => search}, socket) do
    IO.inspect(search)
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    IO.inspect(search)
    {:noreply, socket}
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
