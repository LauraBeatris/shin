defmodule ShinAuth.OIDC do
  @moduledoc """
  OpenID Connect utilities.
  """

  @doc """
  Validates the discovery document of an OIDC provider according to
  the [OpenID Connect Discovery 1.0 spec](https://openid.net/specs/openid-connect-discovery-1_0.html).
  """

  # TODO - Add typespec + doctests
  #
  # @spec validate_provider_configuration(
  #   issuer :: :uri_string.uri_string()
  # ) ::
  #   {:ok, {configuration :: t(), expiry :: pos_integer()}}
  #   | {:error, :validate_provider_configuration.error()}

  def validate_provider_configuration(issuer)
      when is_binary(issuer) do
    case parse_issuer_uri(issuer) do
      {:ok, uri} ->
        uri
        |> get_discovery_url()
        |> fetch_issuer()

      error ->
        error
    end
  end

  def parse_issuer_uri(issuer) do
    case URI.parse(issuer) do
      %URI{scheme: nil} -> {:error, "No URI scheme"}
      %URI{host: nil} -> {:error, "No URI host"}
      uri -> {:ok, uri}
    end
  end

  defp get_discovery_url(issuer) do
    URI.merge(".well-known/openid-configuration", issuer)
  end

  defp fetch_issuer(issuer) do
    # TODO - Verify if issuer is reachable

    {:ok, issuer}
  end
end
