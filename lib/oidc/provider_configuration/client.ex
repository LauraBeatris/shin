defmodule ShinAuth.OIDC.ProviderConfiguration.Client do
  @moduledoc false

  alias ShinAuth.OIDC.ProviderConfiguration.Error
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  def fetch_discovery_metadata(discovery_endpoint, config \\ default_config()) do
    http_client = get_http_client(config)

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

  defp handle_discovery_metadata({:ok, %HTTPoison.Response{body: _, status_code: status_code}}),
    do:
      {:error,
       %Error{
         tag: :discovery_endpoint_unreachable,
         message: "Discovery endpoint is unreachable. Received status code: #{status_code}."
       }}

  defp handle_discovery_metadata(_),
    do:
      {:error,
       %Error{
         tag: :discovery_endpoint_unreachable,
         message:
           "Discovery endpoint is unreachable. Verify if the endpoint is structured correctly."
       }}

  def fetch_authorization_endpoint(
        %Metadata{authorization_endpoint: authorization_endpoint} = metadata,
        config \\ default_config()
      )
      when is_binary(authorization_endpoint) do
    http_client = get_http_client(config)

    response =
      authorization_endpoint
      |> http_client.get(
        [{"Content-Type", "application/json"}, {"Accept", "application/json"}],
        timeout: 5000
      )

    error =
      {:error,
       %Error{
         tag: :authorization_endpoint_unreachable,
         message:
           "'authorization_code' is unreachable. Verify if the endpoint is structured correctly."
       }}

    case response do
      {:ok, %HTTPoison.Response{body: _body, status_code: 500}} ->
        error

      {:error, _} ->
        error

      {:ok, %HTTPoison.Response{body: _body, status_code: _}} ->
        {:ok, metadata}
    end
  end

  def fetch_token_endpoint({:error, _} = error), do: error

  def fetch_token_endpoint(
        {:ok, %Metadata{token_endpoint: token_endpoint} = metadata},
        config \\ default_config()
      )
      when is_binary(token_endpoint) do
    http_client = get_http_client(config)

    response =
      token_endpoint
      |> http_client.post(
        "",
        [{"Content-Type", "application/json"}, {"Accept", "application/json"}],
        timeout: 5000
      )

    error =
      {:error,
       %Error{
         tag: :token_endpoint_unreachable,
         message:
           "'token_endpoint' is unreachable. Verify if the endpoint is structured correctly."
       }}

    case response do
      {:ok, %HTTPoison.Response{body: _body, status_code: 500}} ->
        error

      {:error, _} ->
        error

      {:ok, %HTTPoison.Response{body: _body, status_code: _}} ->
        {:ok, metadata}
    end
  end

  def fetch_jwks_uri({:error, _} = error),
    do: error

  def fetch_jwks_uri(
        {:ok, %Metadata{jwks_uri: jwks_uri} = metadata},
        config \\ default_config()
      )
      when is_binary(jwks_uri) do
    http_client = get_http_client(config)

    response =
      jwks_uri
      |> http_client.get(
        [{"Content-Type", "application/json"}, {"Accept", "application/json"}],
        timeout: 5000
      )

    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        data = Poison.decode!(body)

        case valid_jwk_response?(data) do
          true ->
            {:ok, metadata}

          false ->
            {:error,
             %Error{
               tag: :malformed_jwks_uri_response,
               message: "JWKS URI response is malformed.",
               data: data
             }}
        end

      _ ->
        {:error,
         %Error{
           tag: :jwks_uri_unreachable,
           message: "'jwks_uri' is unreachable. Verify if the endpoint is structured correctly."
         }}
    end
  end

  defp valid_jwk_response?(%{"keys" => keys}) when is_list(keys),
    do: Enum.all?(keys, &validate_jwk_keys/1)

  defp valid_jwk_response?(response) when is_map(response), do: validate_jwk_keys(response)

  defp valid_jwk_response?(_), do: false

  defp validate_jwk_keys(map) do
    Enum.all?(Map.keys(map), fn key ->
      value = Map.fetch!(map, key)
      is_binary(value) or (is_list(value) and Enum.all?(value, &is_binary/1))
    end)
  end

  defp default_config, do: Application.get_env(:shin_auth, :provider_configuration_fetcher)

  defp get_http_client(config) do
    Keyword.get(config, :http_client, HTTPoison)
  end
end
