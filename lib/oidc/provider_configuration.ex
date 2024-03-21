defmodule ShinAuth.OIDC.ProviderConfiguration do
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  def fetch_discovery_metadata(discovery_url, config \\ default_config()) do
    http_client = Keyword.get(config, :http_client)

    discovery_url
    |> http_client.get()
    |> handle_discovery_metadata()
  end

  defp handle_discovery_metadata({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    struct(
      Metadata,
      Poison.decode!(body)
      |> Enum.map(fn {key, value} ->
        {key
         |> to_string()
         |> Macro.underscore()
         |> String.to_atom(), value}
      end)
    )
  end

  defp handle_discovery_metadata(_), do: {:error, "Something went wrong"}

  defp default_config(), do: Application.get_env(:shin_auth, :provider_configuration_fetcher)
end
