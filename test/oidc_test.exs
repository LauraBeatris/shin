defmodule ShinTest.OIDCTest do
  use ExSpec, async: true
  alias ShinAuth.OIDC
  import Mox

  doctest ShinAuth

  @valid_discovery_url "https://valid-url/.well-known/openid-configuration"
  @http_client ShinAuth.HTTPClientMock

  describe "with malformed discovery url" do
    it "returns error" do
      {:error, "Malformed URL. No URI scheme."} =
        OIDC.validate_provider_configuration("invalid")
    end
  end

  describe "with valid discovery url" do
    context "when discovery url is unreachable" do
      it "returns error" do
        expect(@http_client, :get, fn @valid_discovery_url ->
          {:error, %HTTPoison.Response{body: "", status_code: 404}}
        end)

        {:error, _} =
          OIDC.validate_provider_configuration(@valid_discovery_url)
      end
    end
  end
end
