defmodule GithubSearchApp.GithubApi do
  alias GithubSearchApp.UserProfile

  @moduledoc """
  This module is responsible for interacting with the Github API.
  """

  #   @spec search(String.t()) :: {:ok, map()} | {:error, String.t()}
  #   def search(query) do
  #     case HTTPoison.get("https://api.github.com/search/users?q=#{query}") do
  #       {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
  #         {:ok, Poison.decode!(body)}

  #       {:ok, %HTTPoison.Response{status_code: 403}} ->
  #         {:error, "Rate limit exceeded"}

  #       {:ok, %HTTPoison.Response{status_code: 422}} ->
  #         {:error, "Invalid query"}

  #       {:ok, %HTTPoison.Response{status_code: 404}} ->
  #         {:error, "Not found"}

  #       {:error, reason} ->
  #         {:error, reason}
  #     end
  #   end

  #   def search do
  #     query = "mbashia"

  #     case HTTPoison.get("https://api.github.com/search/users?q=#{query}") do
  #       {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
  #         {:ok, Jason.decode!(body)}

  #       {:ok, %HTTPoison.Response{status_code: 304}} ->
  #         {:info, "Not modified "}

  #       {:ok, %HTTPoison.Response{status_code: 422}} ->
  #         {:error, "Validation failed or endpoint has been spammed"}

  #       {:ok, %HTTPoison.Response{status_code: 503}} ->
  #         {:error, "Service unavailable - try again later"}

  #       {:error, reason} ->
  #         {:error, reason}
  #     end
  #   end

  def get_url(search_query) do
    "https://api.github.com/users/#{search_query}"
  end

  def rate_limit_url() do
    "https://api.github.com/rate_limit"
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

      {:ok, %Finch.Response{status: 422}} ->
        {:error, "Validation failed or endpoint has been spammed"}

      {:ok, %Finch.Response{status: 503}} ->
        {:error, "Service unavailable - try again later"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def check_rate_limit() do
    response =
      Finch.build(:get, rate_limit_url())
      |> Finch.request(GithubSearchApp.Finch)

    case response do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %Finch.Response{status: 304}} ->
        {:info, "Not modified"}

      {:ok, %Finch.Response{status: 404}} ->
        {:error, "Not found"}

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
