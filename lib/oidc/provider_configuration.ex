defmodule ShinAuth.OIDC.ProviderConfiguration do
  @moduledoc false

  alias ShinAuth.OIDC.ProviderConfiguration.Client
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  @doc false
  def get_discovery_metadata(discovery_metadata_url) do
    case Client.get(discovery_metadata_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc false
  def get_authorization_endpoint(
        provider_configuration = %Metadata{
          authorization_endpoint: authorization_endpoint
        }
      ) do
    case HTTPoison.get(
           authorization_endpoint,
           Accept: "Application/json; Charset=utf-8",
           "Content-Type": "application/json"
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: _body}} ->
        {:ok, provider_configuration}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
