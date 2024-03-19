defmodule ShinAuth.OIDC do
  @moduledoc """
  OpenID Connect utilities.
  """

  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  @doc """
  Validates provider configuration according to
  the [OpenID Connect Discovery 1.0 spec](https://openid.net/specs/openid-connect-discovery-1_0.html).
  """
  # TODO: Refactor typespecs
  # TODO: Improve flow-control
  # TODO: Move provider configuration functions to separate module
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

  defp get_discovery_endpoint(issuer) do
    parsed_issuer =
      case URI.parse(issuer) do
        %URI{scheme: nil} -> {:error, "Malformed issuer. No URI scheme."}
        %URI{host: nil} -> {:error, "Malformed issuer. No URI host"}
        uri -> {:ok, uri}
      end

    case parsed_issuer do
      {:ok, uri} ->
        {:ok, URI.merge(".well-known/openid-configuration", uri)}

      error ->
        error
    end
  end

  defp fetch_discovery_data(discovery_endpoint) do
    [
      base_url: discovery_endpoint
    ]
    |> Keyword.merge(Application.get_env(:shin_auth, :oidc_discovery_data_req_options, []))
    |> Req.request()
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
      Metadata,
      raw_json
      |> Enum.map(fn {key, value} ->
        {key
         |> to_string()
         |> Macro.underscore()
         |> String.to_atom(), value}
      end)
    )
  end

  defp fetch_authorization_endpoint(
         provider_configuration = %Metadata{
           authorization_endpoint: authorization_endpoint
         }
       ) do
    reach_endpoint(authorization_endpoint, :get)
    |> case do
      {:ok, _} ->
        {:ok, provider_configuration}

      {:error, _} ->
        {:error,
         "Unable to access the authorization endpoint. Ensure the URL is correct and the server is responsive."}
    end
  end

  defp reach_endpoint(base_url, :get) do
    [
      base_url: base_url,
      headers: [{"accept", "application/json"}, {"content-type", "application/json"}],
      method: :get
    ]
    |> Keyword.merge(Application.get_env(:shin_auth, :oidc_is_endpoint_reachable_req, []))
    |> Req.request()
  end
end
