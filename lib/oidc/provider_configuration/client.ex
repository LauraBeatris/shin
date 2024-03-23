defmodule ShinAuth.OIDC.ProviderConfiguration.Client do
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata
  alias ShinAuth.OIDC.ProviderConfiguration.Error

  def fetch_discovery_metadata(discovery_endpoint, config \\ default_config()) do
    http_client = Keyword.get(config, :http_client)

    discovery_endpoint
    |> http_client.get()
    |> handle_discovery_metadata()
  end

  defp handle_discovery_metadata({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    {:ok,
     struct(
       Metadata,
       Poison.decode!(body)
       |> Enum.map(fn {key, value} ->
         {key
          |> to_string()
          |> Macro.underscore()
          |> String.to_atom(), value}
       end)
     )}
  end

  defp handle_discovery_metadata(_),
    do:
      {:error,
       %Error{
         tag: :discovery_endpoint_unreachable,
         message: "Discovery endpoint is unreachable"
       }}

  def fetch_authorization_endpoint(
        %Metadata{authorization_endpoint: authorization_endpoint} = metadata,
        config \\ default_config()
      )
      when is_binary(authorization_endpoint) do
    http_client = Keyword.get(config, :http_client)

    response =
      authorization_endpoint
      |> http_client.get(
        [{"Content-Type", "application/json"}, {"Accept", "application/json"}],
        timeout: 5000
      )

    case response do
      {:ok, %HTTPoison.Response{body: _body, status_code: 400}} ->
        {:ok, metadata}

      {:ok, %HTTPoison.Response{body: _body, status_code: 200}} ->
        {:ok, metadata}

      _ ->
        {:error,
         %Error{
           tag: :authorization_endpoint_unreachable,
           message: "Authorization endpoint is unreachable"
         }}
    end
  end

  def fetch_jwks_uri({:error, _} = error),
    do: error

  def fetch_jwks_uri(
        {:ok, %Metadata{jwks_uri: jwks_uri} = metadata},
        config \\ default_config()
      )
      when is_binary(jwks_uri) do
    http_client = Keyword.get(config, :http_client)

    response =
      jwks_uri
      |> http_client.get(
        [{"Content-Type", "application/json"}, {"Accept", "application/json"}],
        timeout: 5000
      )

    case response do
      # TODO - Validate JWKS body
      {:ok, %HTTPoison.Response{body: _body, status_code: 200}} ->
        {:ok, metadata}

      _ ->
        {:error,
         %Error{
           tag: :jwks_uri_unreachable,
           message: "JWKS URI is unreachable"
         }}
    end
  end

  defp default_config(), do: Application.get_env(:shin_auth, :provider_configuration_fetcher)
end
