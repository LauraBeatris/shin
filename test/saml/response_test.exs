defmodule ShinAuth.SAML.ResponseTest do
  use ExSpec, async: true

  alias ShinAuth.SAML
  alias ShinAuth.SAML.Response

  describe "with malformed saml response" do
    context "with empty xml" do
      it "returns error" do
        {:error,
         %Response.Error{
           tag: :malformed_saml_response,
           message:
             "Verify if the SAML response is structured correctly by the Identity Provider."
         }} = SAML.decode_saml_response("")
      end
    end

    context "with malformed xml element" do
      it "returns error" do
        {:error,
         %Response.Error{
           tag: :malformed_saml_response,
           message:
             "Verify if the SAML response is structured correctly by the Identity Provider."
         }} =
          SAML.decode_saml_response("""
          <Invalid
          """)
      end
    end

    context "when missing required element" do
      it "returns error" do
        {:error,
         %Response.Error{
           tag: :malformed_saml_response,
           message:
             "Verify if the SAML response is structured correctly by the Identity Provider."
         }} = SAML.decode_saml_response(get_xml("saml_response_missing_element"))
      end
    end
  end

  describe "with valid saml response" do
    it "returns parsed response struct" do
      {:ok,
       %Response{
         id: "_123",
         version: "2.0",
         destination: "https://api.example.com/sso/saml/acs/123",
         issuer: "https://example.com/1234/issuer/1234",
         issue_instant: "2024-03-23T20:56:56.768Z"
       }} = SAML.decode_saml_response(get_xml("valid_saml_response"))
    end
  end

  defp get_xml(filename) do
    Path.join([__DIR__, "../support/saml", filename <> ".xml"])
    |> File.read!()
  end
end
