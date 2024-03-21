defmodule ShinTest.OIDCTest do
  import Mox

  use ExSpec, async: true

  alias ShinAuth.OIDC
  alias ShinAuth.OIDC.ProviderConfiguration.Error

  doctest ShinAuth

  @valid_discovery_endpoint "https://valid-url/.well-known/openid-configuration"
  @http_client ShinAuth.HTTPClientMock

  describe "with malformed discovery endpoint" do
    it "returns error" do
      {:error,
       %Error{
         severity: :error,
         tag: :malformed_discovery_endpoint,
         message: "Malformed URL. No URI scheme."
       }} =
        OIDC.load_provider_configuration("invalid")
    end
  end

  describe "with valid discovery url" do
    context "when discovery url is unreachable" do
      it "returns error" do
        expect(@http_client, :get, fn @valid_discovery_endpoint ->
          {:error, %HTTPoison.Response{body: "", status_code: 500}}
        end)

        {:error, _} =
          OIDC.load_provider_configuration(@valid_discovery_endpoint)
      end
    end
  end
end
