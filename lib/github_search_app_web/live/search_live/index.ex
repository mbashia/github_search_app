defmodule GithubSearchAppWeb.SearchLive.Index do
  use GithubSearchAppWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    ## djdjdjd
    {:ok,
     socket
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
end
