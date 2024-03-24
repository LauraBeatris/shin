defmodule ShinAuth.SAML do
  @moduledoc """
  Security Assertion Markup Language utilities.

  Performs decoding based on the spec: https://docs.oasis-open.org/security/saml/v2.0/saml-core-2.0-os.pdf
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

    if valid_xml?(saml_request) do
      case DataSchema.to_struct(saml_request, Request) do
        {:ok, parsed_saml_request} -> {:ok, parsed_saml_request}
        {:error, _} = error -> error
      end
    else
      {:error, error}
    end
  end

  defp valid_xml?(xml_string) do
    SweetXml.parse(xml_string, quiet: true)
    true
  catch
    :exit, _ -> false
    :error, _ -> false
  end
end
