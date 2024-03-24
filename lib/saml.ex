defmodule ShinAuth.SAML do
  @moduledoc """
  Security Assertion Markup Language utilities.
  """

  alias ShinAuth.SAML.Request

  def decode_saml_request(saml_request) do
    parsed_saml_request = DataSchema.to_struct(saml_request, Request)

    case parsed_saml_request do
      {:error, _} -> {:error, "Invalid SAML request"}
      _ -> parsed_saml_request
    end
  end
end
