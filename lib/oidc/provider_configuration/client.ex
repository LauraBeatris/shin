defmodule ShinAuth.OIDC.ProviderConfiguration.Client do
  use HTTPoison.Base

  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  def process_response_body(body) do
    body
    |> Poison.decode!(as: %Metadata{})
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
