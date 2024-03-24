defmodule ShinAuth.SAML do
  @moduledoc """
  Security Assertion Markup Language utilities.

  Performs decoding and validation based on the spec: https://docs.oasis-open.org/security/saml/v2.0/saml-core-2.0-os.pdf
  """

  alias ShinAuth.SAML.Request

  @doc """
  Performs decoding on a given SAML request XML document
  """
  @spec decode_saml_request(discovery_endpoint :: :uri_string.uri_string()) ::
          {:ok, Request.t()}
          | {:error, Request.Error.t()}

  def decode_saml_request(""),
    do:
      {:error,
       %Request.Error{
         tag: :malformed_saml_request,
         message: "Verify if the SAML request is structured correctly by the Service Provider."
       }}

  def decode_saml_request(saml_request) do
    error = %Request.Error{
      tag: :malformed_saml_request,
      message: "Verify if the SAML request is structured correctly by the Service Provider."
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
