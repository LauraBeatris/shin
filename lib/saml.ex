defmodule ShinAuth.SAML do
  @moduledoc """
  Security Assertion Markup Language utilities.
  """

  alias ShinAuth.SAML.Request

  def decode_saml_request(""), do: {:error, "Empty SAML request"}

  def decode_saml_request(saml_request) do
    if is_valid_xml?(saml_request) do
      case DataSchema.to_struct(saml_request, Request) do
        {:ok, parsed_saml_request} -> {:ok, parsed_saml_request}
        {:error, _} = error -> error
      end
    else
      {:error, "Invalid SAML request"}
    end
  end

  defp is_valid_xml?(xml_string) do
    try do
      SweetXml.parse(xml_string, quiet: true)
      true
    catch
      :exit, _ -> false
      :error, _ -> false
    end
  end
end
