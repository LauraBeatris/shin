defmodule ShinAuth.SAML.RequestTest do
  use ExSpec, async: true

  alias ShinAuth.SAML
  alias ShinAuth.SAML.Request

  describe "with malformed saml request" do
    context "with empty xml" do
      it "returns error" do
        {:error,
         %Request.Error{
           tag: :malformed_saml_request,
           message: "Verify if the SAML request is structured correctly by the Service Provider."
         }} = SAML.decode_saml_request("")
      end
    end

    context "with malformed xml element" do
      it "returns error" do
        {:error,
         %Request.Error{
           tag: :malformed_saml_request,
           message: "Verify if the SAML request is structured correctly by the Service Provider."
         }} =
          SAML.decode_saml_request("""
          <Invalid
          """)
      end
    end

    context "when missing saml request required element" do
      saml_request_mock = """
      <?xml version="1.0"?>
      <samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" ID="_123" Version="2.0" IssueInstant="2023-09-27T17:20:42.746Z" ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Destination="https://accounts.google.com/o/saml2/idp?idpid=C03gu405z" AssertionConsumerServiceURL="https://auth.example.com/sso/saml/acs/123">
      <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress" AllowCreate="true"/>
      </samlp:AuthnRequest>
      """

      {:error,
       %DataSchema.Errors{
         errors: [issuer: "Field was required but value supplied is considered empty"]
       }} = SAML.decode_saml_request(saml_request_mock)
    end
  end

  describe "with valid saml request" do
    context "returns parsed request struct" do
      saml_request_mock = """
      <?xml version="1.0"?>
      <samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" ID="_123" Version="2.0" IssueInstant="2023-09-27T17:20:42.746Z" ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Destination="https://accounts.google.com/o/saml2/idp?idpid=C03gu405z" AssertionConsumerServiceURL="https://auth.example.com/sso/saml/acs/123">
      <saml:Issuer xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">
        https://example.com/123
      </saml:Issuer>
      <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress" AllowCreate="true"/>
      </samlp:AuthnRequest>
      """

      {:ok,
       %Request{
         id: "_123",
         version: "2.0",
         issue_instant: "2023-09-27T17:20:42.746Z",
         issuer: "https://example.com/123",
         assertion_consumer_service_url: "https://auth.example.com/sso/saml/acs/123"
       }} = SAML.decode_saml_request(saml_request_mock)
    end
  end
end
