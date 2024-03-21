defmodule ShinAuth.OIDC do
  @moduledoc """
  OpenID Connect utilities.
  """

  alias ShinAuth.OIDC.ProviderConfiguration.Metadata
  import ShinAuth.OIDC.ProviderConfiguration

  @discovery_metadata_url_path ".well-known/openid-configuration"

  @doc """
  Validates provider configuration according to
  the [OpenID Connect Discovery 1.0 spec](https://openid.net/specs/openid-connect-discovery-1_0.html).
  """
  @spec validate_provider_configuration(discovery_metadata_url :: :uri_string.uri_string()) ::
          {:ok, Metadata.t()}
          | {:error, any()}
  def validate_provider_configuration(discovery_metadata_url)
      when is_binary(discovery_metadata_url) do
    case validate_discovery_metadata_url(discovery_metadata_url) do
      {:ok, _} ->
        get_discovery_metadata(discovery_metadata_url)

      error ->
        error
    end
  end

  defp validate_discovery_metadata_url(discovery_metadata_url)
       when is_binary(discovery_metadata_url) do
    case URI.parse(discovery_metadata_url) do
      %URI{scheme: nil} -> {:error, "Malformed issuer. No URI scheme."}
      %URI{host: nil} -> {:error, "Malformed issuer. No URI host"}
      _ -> {:ok, append_discovery_metadata_path(discovery_metadata_url)}
    end
  end

  defp append_discovery_metadata_path(discovery_metadata_url) do
    case String.ends_with?(discovery_metadata_url, @discovery_metadata_url_path) do
      true ->
        discovery_metadata_url

      false ->
        "#{String.trim_trailing(discovery_metadata_url, "/")}/#{@discovery_metadata_url_path}"
    end
  end
end
