defmodule ShinAuth.OIDC.ProviderConfiguration.Client do
  use HTTPoison.Base

  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  def process_response_body(body) do
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
end
