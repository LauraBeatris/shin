defmodule ShinTest do
  use ExSpec, async: true

  doctest ShinAuth

  alias ShinAuth.OIDC
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  describe "validate_provider_configuration" do
    context "with invalid issuer" do
      it "returns error" do
        {:error, "Malformed issuer. No URI scheme."} =
          OIDC.validate_provider_configuration("invalid-issuer.com")
      end
    end

    context "when the discovery metadata endpoint is unreachable" do
      it "returns error" do
        {:error, "An error occurred while fetching the discovery document."} =
          OIDC.validate_provider_configuration("https://example.com")
      end
    end

    context "when the discovery metadata endpoint is reachable and has valid content" do
      it "returns parsed provider configuration" do
        {:ok, %Metadata{issuer: "https://example.com"}} =
          OIDC.validate_provider_configuration("https://example.com")
      end
    end
  end
end
