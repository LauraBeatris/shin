defmodule ShinTest do
  use ExSpec, async: true

  doctest ShinAuth

  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  @metadata %{
    "issuer" => "https://valid-issuer.com",
    "authorization_endpoint" => "https://valid-authorization-endpoint.com"
  }

  describe "validate_provider_configuration" do
    context "with invalid issuer" do
      it "returns error" do
        {:error, "Malformed issuer. No URI scheme."} =
          ShinAuth.OIDC.validate_provider_configuration("invalid-issuer.com")
      end
    end

    context "when failing to fetch discovery data" do
      it "returns error" do
        Req.Test.stub(ShinAuth.OIDC, fn conn ->
          Plug.Conn.send_resp(conn, 403, "Forbidden")
        end)

        {:error, "An error occurred while fetching the discovery document."} =
          ShinAuth.OIDC.validate_provider_configuration("https://valid-issuer.com")
      end
    end

    context "when successfully fetching discovery data" do
      it "returns parsed provider configuration" do
        Req.Test.stub(ShinAuth.OIDC, fn conn ->
          Req.Test.json(conn, @metadata)
        end)

        {:ok, %Metadata{issuer: "https://valid-issuer.com"}} =
          ShinAuth.OIDC.validate_provider_configuration("https://valid-issuer.com")
      end
    end
  end
end
