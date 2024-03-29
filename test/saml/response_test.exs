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
         common: %{
           id: "_8f3b2c4d9e7a8b5c6d21",
           version: "2.0",
           destination: "https://app.shin.com/tester/samlp",
           issuer: "urn:example.shin.name",
           issue_instant: "2014-10-14T14:32:17Z"
         }
       }} = SAML.decode_saml_response(get_xml("valid_saml_response"))
    end
  end

  defp get_xml(filename) do
    Path.join([__DIR__, "../support/saml", filename <> ".xml"])
    |> File.read!()
  end
end
