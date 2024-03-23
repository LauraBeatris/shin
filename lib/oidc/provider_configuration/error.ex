defmodule ShinAuth.OIDC.ProviderConfiguration.Error do
  @type t :: %__MODULE__{
          tag:
            :malformed_discovery_endpoint
            | :discovery_endpoint_unreachable
            | :authorization_endpoint_unreachable
            | :token_endpoint_unreachable
            | :malformed_jwks_uri_response
            | :jwks_uri_unreachable
            | :missing_issuer_attribute,
          message: String.t(),
          data: any() | nil,
          endpoint: String.t() | nil
        }

  defexception [:tag, :message, :data, :endpoint]

  def message(%{tag: _tag, data: _data, endpoint: _endpoint, message: message}) do
    message
  end
end
