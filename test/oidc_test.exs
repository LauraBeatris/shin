defmodule ShinAuth.OIDCTest do
  import Mox

  use ExSpec, async: true

  alias ShinAuth.OIDC
  alias ShinAuth.OIDC.ProviderConfiguration.Error
  alias ShinAuth.OIDC.ProviderConfiguration.Metadata

  @valid_discovery_endpoint "https://valid-url/.well-known/openid-configuration"
  @http_client ShinAuth.HTTPClientMock

  describe "with malformed discovery endpoint" do
    it "returns error" do
      {:error,
       %Error{
         tag: :malformed_discovery_endpoint,
         message: "Discovery endpoint has no URI scheme."
       }} =
        OIDC.load_provider_configuration("invalid")
    end
  end

  describe "when discovery endpoint is unreachable" do
    it "returns error" do
      mock_discovery_metadata(:unreachable)

      {:error,
       %Error{
         tag: :discovery_endpoint_unreachable,
         message: "Discovery endpoint is unreachable. Received status code: 500."
       }} =
        OIDC.load_provider_configuration(@valid_discovery_endpoint)
    end
  end

  describe "when discovery endpoint is reachable" do
    context "with valid metadata" do
      it "returns parsed metadata" do
        mock_discovery_metadata(:reachable)
        mock_authorization_endpoint(:reachable)
        mock_jwks_uri(:reachable)
        mock_token_endpoint(:reachable)

        {:ok, %Metadata{issuer: "https://foo-corp-sandbox.idp-example.com"}} =
          OIDC.load_provider_configuration(@valid_discovery_endpoint)
      end
    end

    context "with unreachable authorization endpoint" do
      it "returns error" do
        mock_discovery_metadata(:reachable)
        mock_authorization_endpoint(:unreachable)

        {:error,
         %Error{
           tag: :authorization_endpoint_unreachable,
           message:
             "'authorization_code' is unreachable. Verify if the endpoint is structured correctly."
         }} =
          OIDC.load_provider_configuration(@valid_discovery_endpoint)
      end
    end

    context "without 'issuer' attribute" do
      it "returns error" do
        mock_discovery_metadata(:reachable, get_json("discovery_metadata_without_issuer"))
        mock_authorization_endpoint(:reachable)

        {:error,
         %Error{
           tag: :missing_issuer_attribute,
           message:
             "'issuer' attribute is missing. Ensure the OIDC provider supports the 'issuer' attribute."
         }} =
          OIDC.load_provider_configuration(@valid_discovery_endpoint)
      end
    end

    context "with unreachable 'jwks_uri'" do
      it "returns error" do
        mock_discovery_metadata(:reachable)
        mock_authorization_endpoint(:reachable)
        mock_jwks_uri(:unreachable)

        {:error,
         %Error{
           tag: :jwks_uri_unreachable,
           message: "'jwks_uri' is unreachable. Verify if the endpoint is structured correctly."
         }} =
          OIDC.load_provider_configuration(@valid_discovery_endpoint)
      end
    end

    context "with malformed 'jwks_uri' response" do
      it "returns error" do
        mock_discovery_metadata(:reachable)
        mock_authorization_endpoint(:reachable)
        mock_jwks_uri(:reachable, %{"foo" => true})

        {:error,
         %Error{
           tag: :malformed_jwks_uri_response,
           message: "JWKS URI response is malformed.",
           data: %{"foo" => true}
         }} =
          OIDC.load_provider_configuration(@valid_discovery_endpoint)
      end
    end

    context "with unreachable 'token_endpoint'" do
      it "returns error" do
        mock_discovery_metadata(:reachable)
        mock_authorization_endpoint(:reachable)
        mock_jwks_uri(:reachable)
        mock_token_endpoint(:unreachable)

        {:error,
         %Error{
           tag: :token_endpoint_unreachable,
           message:
             "'token_endpoint' is unreachable. Verify if the endpoint is structured correctly."
         }} =
          OIDC.load_provider_configuration(@valid_discovery_endpoint)
      end
    end
  end

  defp get_json(filename) do
    Path.join(__DIR__, ["support/oidc/", filename <> ".json"])
    |> File.read!()
  end

  defp mock_discovery_metadata(status, body \\ get_json("valid_discovery_metadata")) do
    expect(@http_client, :get, fn
      @valid_discovery_endpoint ->
        case status do
          :reachable ->
            {:ok, %HTTPoison.Response{body: body, status_code: 200}}

          :unreachable ->
            {:ok, %HTTPoison.Response{body: "", status_code: 500}}
        end
    end)
  end

  defp mock_authorization_endpoint(status) do
    expect(@http_client, :get, fn
      "https://foo-corp-sandbox.idp-example.com/oauth2/v1/authorize",
      [{"Content-Type", "application/json"}, {"Accept", "application/json"}],
      [timeout: 5000] ->
        case status do
          :reachable ->
            {:ok,
             %HTTPoison.Response{body: "Invalid 'client_id' parameter value", status_code: 400}}

          :unreachable ->
            {:ok, %HTTPoison.Response{body: "", status_code: 500}}
        end
    end)
  end

  defp mock_jwks_uri(
         status,
         body \\ %{
           "keys" => [
             %{
               "alg" => "RS256",
               "e" => "AQAB"
             }
           ]
         }
       ) do
    expect(@http_client, :get, fn
      "https://foo-corp-sandbox.idp-example.com/oauth2/v1/keys",
      [{"Content-Type", "application/json"}, {"Accept", "application/json"}],
      [timeout: 5000] ->
        case status do
          :reachable ->
            {:ok,
             %HTTPoison.Response{
               body: Poison.encode!(body),
               status_code: 200
             }}

          :unreachable ->
            {:ok, %HTTPoison.Response{body: "", status_code: 500}}
        end
    end)
  end

  defp mock_token_endpoint(status) do
    expect(@http_client, :post, fn
      "https://foo-corp-sandbox.idp-example.com/oauth2/v1/token", _body, _headers, _options ->
        case status do
          :reachable ->
            {:ok,
             %HTTPoison.Response{body: "Invalid 'client_id' parameter value", status_code: 400}}

          :unreachable ->
            {:ok, %HTTPoison.Response{body: "", status_code: 500}}
        end
    end)
  end
end
