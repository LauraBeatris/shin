defmodule ShinAuth.OIDC.ProviderConfiguration do
  @moduledoc false

  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  @doc false
  def fetch_discovery_metadata(issuer) do
    discovery_endpoint_result =
      case get_discovery_endpoint(issuer) do
        {:ok, _} = endpoint ->
          endpoint

        error ->
          error
      end

    with {:ok, discovery_endpoint} <- discovery_endpoint_result do
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
    else
      error -> error
    end
  end

  @doc false
  def reach_authorization_endpoint(
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

  defp reach_endpoint(base_url, :get) do
    [
      base_url: base_url,
      headers: [{"accept", "application/json"}, {"content-type", "application/json"}],
      method: :get
    ]
    |> Keyword.merge(Application.get_env(:shin_auth, :oidc_reach_metadata_endpoint_req, []))
    |> Req.request()
  end
end
