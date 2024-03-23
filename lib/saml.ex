defmodule ShinAuth.SAML do
  @moduledoc """
  Security Assertion Markup Language utilities.
  """

  alias ShinAuth.SAML.Request

  def decode_saml_request do
    saml_request_xml = "<?xml version=\"1.0\"?>
    <samlp:AuthnRequest xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\" ID=\"_01HSPHM4R68D2XY7V90H8NR815\" Version=\"2.0\" IssueInstant=\"2024-03-23T20:56:49.158Z\" ProtocolBinding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST\" AssertionConsumerServiceURL=\"https://auth.workos.com/sso/saml/acs/CHzm4yYDWdLFSjzamDIUfDz1x\">
        <saml:Issuer xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\">
            https://auth.workos.com/CHzm4yYDWdLFSjzamDIUfDz1x
        </saml:Issuer>
        <samlp:NameIDPolicy Format=\"urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress\" AllowCreate=\"true\"/>
    </samlp:AuthnRequest>"

    #   XML binary =>
    # Saxy (to create a SimpleForm DOM) =>
    #   Query that DOM with DataSchema =>
    #     Struct
  end
end
