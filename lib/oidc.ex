defmodule ShinAuth.OIDC do
  @moduledoc """
  OpenID Connect utilities.
  """

  import ShinAuth.OIDC.ProviderConfiguration
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata
  alias ShinAuth.OIDC.ProviderConfiguration.Error

  @discovery_endpoint_path ".well-known/openid-configuration"

  @doc """
  Loads provider configuration according to
  the [OpenID Connect Discovery 1.0 spec](https://openid.net/specs/openid-connect-discovery-1_0.html).
  """
  @spec load_provider_configuration(discovery_endpoint :: :uri_string.uri_string()) ::
          {:ok, Metadata.t()}
          | {:error, Error.t()}
  def load_provider_configuration(discovery_endpoint)
      when is_binary(discovery_endpoint) do
    case validate_discovery_endpoint(discovery_endpoint) do
      {:ok, _} ->
        discovery_endpoint |> fetch_discovery_metadata() |> validate_discovery_metadata()

      error ->
        error
    end
  end

  defp validate_discovery_metadata({:ok, metadata}) do
    validation_result =
      metadata |> fetch_authorization_endpoint

    case validation_result do
      {:error, _} = error -> error
      {:ok, _} = parsed_metadata -> parsed_metadata
    end
  end

  defp validate_discovery_metadata({:error, _} = error), do: error

  defp validate_discovery_endpoint(discovery_endpoint)
       when is_binary(discovery_endpoint) do
    case URI.parse(discovery_endpoint) do
      %URI{scheme: nil} ->
        {:error,
         %Error{
           severity: :error,
           tag: :malformed_discovery_endpoint,
           message: "Discovery endpoint has no URI scheme"
         }}

      %URI{host: nil} ->
        {:error,
         %Error{
           severity: :error,
           tag: :malformed_discovery_endpoint,
           message: "Discovery endpoint has no URI host"
         }}

      _ ->
        {:ok, append_discovery_path(discovery_endpoint)}
    end
  end

  defp append_discovery_path(discovery_endpoint) do
    case String.ends_with?(discovery_endpoint, @discovery_endpoint_path) do
      true ->
        discovery_endpoint

      false ->
        "#{String.trim_trailing(discovery_endpoint, "/")}/#{@discovery_endpoint_path}"
    end
  end
end
