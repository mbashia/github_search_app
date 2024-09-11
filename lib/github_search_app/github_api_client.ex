defmodule GithubSearchApp.GithubApiClient do
  alias GithubSearchApp.UserProfile

  @moduledoc """
  This module is responsible for interacting with the Github API.
  """
  @behaviour GithubSearchApp.GithubClientBehaviour

  def get_url(search_query) do
    "https://api.github.com/users/#{search_query}"
  end

  def search_github(query) do
    url = get_url(query)

    response =
      Finch.build(:get, url)
      |> Finch.request(GithubSearchApp.Finch)

    case response do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        {:ok, process_success_results(body)}

      {:ok, %Finch.Response{status: 304}} ->
        {:info, "Not modified"}

      {:ok, %Finch.Response{status: 404, body: body}} ->
        Jason.decode!(body) |> IO.inspect(label: "body")
        {:error, "Not found"}

      {:ok, %Finch.Response{status: 422}} ->
        {:error, "Validation failed or endpoint has been spammed"}

      {:ok, %Finch.Response{status: 503}} ->
        {:error, "Service unavailable - try again later"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def process_success_results(body) do
    body |> Jason.decode!() |> process_user()
  end

  def process_user(body) do
    %UserProfile{
      avatar_url: body["avatar_url"],
      bio: body["bio"],
      blog: body["blog"],
      company: body["company"],
      created_at: body["created_at"],
      email: body["email"],
      followers: body["followers"],
      following: body["following"],
      location: body["location"],
      login: body["login"],
      name: body["name"],
      profile_url: body["html_url"],
      public_repos: body["public_repos"],
      twitter_username: body["twitter_username"]
    }
  end
end
