defmodule ShinAuth.SAML do
  @moduledoc """
  Security Assertion Markup Language utilities.
  """

  alias ShinAuth.SAML.Request

  @spec decode_saml_request(discovery_endpoint :: :uri_string.uri_string()) ::
          {:ok, any()}
          | {:error, Request.Error.t()}

  def decode_saml_request(""), do: {:error, "Empty SAML request"}

  def decode_saml_request(saml_request) do
    error = %Request.Error{
      tag: :malformed_saml_request,
      message: "Invalid SAML request"
    }

    if is_valid_xml?(saml_request) do
      case DataSchema.to_struct(saml_request, Request) do
        {:ok, parsed_saml_request} -> {:ok, parsed_saml_request}
        {:error, _} = error -> error
      end
    else
      {:error, error}
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
