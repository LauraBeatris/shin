defmodule ShinTest.OIDCTest do
  import Mox

  use ExSpec, async: true

  alias ShinAuth.OIDC
  alias ShinAuth.OIDC.ProviderConfiguration.Error
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  doctest ShinAuth

  @valid_discovery_endpoint "https://valid-url/.well-known/openid-configuration"
  @http_client ShinAuth.HTTPClientMock

  def get_json(filename) do
    Path.join(__DIR__, ["support/", filename <> ".json"])
    |> File.read!()
  end

  defp mock_discovery_content(%{with_discovery: with_discovery}) do
    if with_discovery do
      expect(@http_client, :get, fn @valid_discovery_endpoint ->
        {:ok, %HTTPoison.Response{body: get_json("valid_discovery_metadata"), status_code: 200}}
      end)
    else
      expect(@http_client, :get, fn @valid_discovery_endpoint ->
        {:error, %HTTPoison.Response{body: "", status_code: 500}}
      end)
    end
  end

  describe "with malformed discovery endpoint" do
    it "returns error" do
      {:error,
       %Error{
         severity: :error,
         tag: :malformed_discovery_endpoint,
         message: "Discovery endpoint has no URI scheme"
       }} =
        OIDC.load_provider_configuration("invalid")
    end
  end

  describe "when discovery endpoint is unreachable" do
    it "returns error" do
      mock_discovery_content(%{
        with_discovery: false
      })

      {:error,
       %Error{
         severity: :error,
         tag: :discovery_endpoint_unreachable,
         message: "Discovery endpoint is unreachable"
       }} =
        OIDC.load_provider_configuration(@valid_discovery_endpoint)
    end
  end

  describe "when discovery endpoint is reachable" do
    it "returns parsed discovery metadata" do
      mock_discovery_content(%{
        with_discovery: true
      })

      {:ok, %Metadata{issuer: "https://foo-corp-sandbox.idp-example.com"}} =
        OIDC.load_provider_configuration(@valid_discovery_endpoint)
    end
  end
end
