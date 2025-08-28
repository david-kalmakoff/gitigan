defmodule PocketId do
  use OAuth2.Strategy

  @moduledoc """
  OAuth2 Strategy for Pocket API

  Repo: https://github.com/ueberauth/oauth2
  Example: https://github.com/scrogson/oauth2_example
  """

  # Public API

  def client do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: Application.fetch_env!(:gitigan, PocketId)[:client_id],
      client_secret: Application.fetch_env!(:gitigan, PocketId)[:client_secret],
      redirect_uri: Application.fetch_env!(:gitigan, PocketId)[:redirect_uri],
      site: Application.fetch_env!(:gitigan, PocketId)[:site],
      authorize_url: Application.fetch_env!(:gitigan, PocketId)[:authorize_url],
      token_url: Application.fetch_env!(:gitigan, PocketId)[:token_url]
    )
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "user,email")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ []) do
    OAuth2.Client.get_token!(
      client(),
      Keyword.merge(params, client_secret: client().client_secret)
    )
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  def get_user!(token) when is_binary(token) do
    client = OAuth2.Client.new(client(), token: token)
    %{body: user} = OAuth2.Client.get!(client, "/api/oidc/userinfo")
    %{email: user["email"]}
  end

  def get_user!(client) do
    %{body: user} = OAuth2.Client.get!(client, "/api/oidc/userinfo")
    %{email: user["email"]}
  end
end
