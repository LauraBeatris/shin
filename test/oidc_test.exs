defmodule ShinTest do
  use ExSpec, async: true

  doctest ShinAuth

  describe "validate_provider_configuration" do
    context "with invalid issuer" do
      it "returns error" do
        {:error, "No URI scheme"} =
          ShinAuth.OIDC.validate_provider_configuration("invalid-issuer.com")
      end
    end
  end
end
