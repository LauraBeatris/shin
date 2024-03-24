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

    context "when missing required element" do
      it "returns error" do
        {:error,
         %Request.Error{
           tag: :malformed_saml_request,
           message: "Verify if the SAML request is structured correctly by the Service Provider."
         }} = SAML.decode_saml_request(get_xml("saml_request_missing_element"))
      end
    end
  end

  describe "with valid saml request" do
    it "returns parsed request struct" do
      {:ok,
       %Request{
         common: %{
           id: "_123",
           version: "2.0",
           issue_instant: "2023-09-27T17:20:42.746Z",
           issuer: "https://example.com/123",
           assertion_consumer_service_url: "https://auth.example.com/sso/saml/acs/123"
         }
       }} = SAML.decode_saml_request(get_xml("valid_saml_request"))
    end
  end

  defp get_xml(filename) do
    Path.join([__DIR__, "../support/saml", filename <> ".xml"])
    |> File.read!()
  end
end
