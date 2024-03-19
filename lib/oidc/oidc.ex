defmodule ShinAuth.OIDC do
  @moduledoc """
  OpenID Connect utilities.
  """

  alias ShinAuth.OIDC.ProviderConfiguration.Metadata
  import ShinAuth.OIDC.ProviderConfiguration

  @doc """
  Validates provider configuration according to
  the [OpenID Connect Discovery 1.0 spec](https://openid.net/specs/openid-connect-discovery-1_0.html).
  """
  @spec validate_provider_configuration(issuer :: :uri_string.uri_string()) ::
          {:ok, Metadata.t()}
          | {:error, any()}
  def validate_provider_configuration(issuer)
      when is_binary(issuer) do
    discovery_data =
      case get_discovery_endpoint(issuer) do
        {:ok, url} ->
          fetch_discovery_data(url)

        error ->
          error
      end

    with {:ok, provider_configuration} <- discovery_data do
      provider_configuration |> fetch_authorization_endpoint
    else
      error -> error
    end
  end
end
