defmodule GithubSearchApp.GithubClientBehaviour do
  @moduledoc """
  This module defines the behaviour for the Github API client.
  """

  @callback search_github(String.t()) ::
              {:ok, GithubSearchApp.UserProfile.t()} | {:info, String.t()} | {:error, String.t()}
end
