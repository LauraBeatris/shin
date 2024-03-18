defmodule ShinAuth.OIDC do
  @moduledoc """
  OpenID Connect utilities.
  """

  @doc """
  Validates provider configuration according to
  the [OpenID Connect Discovery 1.0 spec](https://openid.net/specs/openid-connect-discovery-1_0.html).
  """

  # TODO - Update typespec with config struct and errors
  @spec validate_provider_configuration(issuer :: :uri_string.uri_string()) ::
          {:ok, any()}
          | {:error, any()}
  def validate_provider_configuration(issuer)
      when is_binary(issuer) do
    case parse_issuer_uri(issuer) do
      {:ok, uri} ->
        uri
        |> get_discovery_url()
        |> fetch_discovery_data()

      error ->
        error
    end
  end

  def parse_issuer_uri(issuer) do
    case URI.parse(issuer) do
      %URI{scheme: nil} -> {:error, "Malformed issuer. No URI scheme."}
      %URI{host: nil} -> {:error, "Malformed issuer. No URI host"}
      uri -> {:ok, uri}
    end
  end

  defp get_discovery_url(issuer) do
    URI.merge(".well-known/openid-configuration", issuer)
  end

  defp fetch_discovery_data(issuer) do
    Req.get(issuer)
    |> case do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, parse_discovery_data(body)}

      {:ok, _} ->
        {:error, "An error occurred while fetching the discovery document."}

      {:error, _} ->
        {:error, "An error occurred while fetching the discovery document."}
    end
  end

  defp parse_discovery_data(raw_json) do
    struct(
      ShinAuth.OIDC.ProviderConfiguration,
      raw_json
      |> Enum.map(fn {key, value} ->
        {key
         |> to_string()
         |> Macro.underscore()
         |> String.to_atom(), value}
      end)
    )
  end
end
