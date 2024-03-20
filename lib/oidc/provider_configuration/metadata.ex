defmodule ShinAuth.OIDC.ProviderConfiguration.Metadata do
  @moduledoc """
  OpenID Connect Provider Configuration

  For details on the fields see:
  * https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata
  * https://datatracker.ietf.org/doc/html/draft-jones-oauth-discovery-01#section-4.1
  * https://openid.net/specs/openid-connect-rpinitiated-1_0.html#OPMetadata
  """

  defstruct [
    :issuer,
    :authorization_endpoint,
    :token_endpoint,
    :userinfo_endpoint,
    :jwks_uri,
    :registration_endpoint,
    :scopes_supported,
    :response_types_supported,
    :response_modes_supported,
    :grant_types_supported,
    :acr_values_supported,
    :subject_types_supported,
    :id_token_signing_alg_values_supported,
    :id_token_encryption_alg_values_supported,
    :id_token_encryption_enc_values_supported,
    :userinfo_signing_alg_values_supported,
    :userinfo_encryption_alg_values_supported,
    :userinfo_encryption_enc_values_supported,
    :request_object_signing_alg_values_supported,
    :request_object_encryption_alg_values_supported,
    :request_object_encryption_enc_values_supported,
    :token_endpoint_auth_methods_supported,
    :token_endpoint_auth_signing_alg_values_supported,
    :display_values_supported,
    :claim_types_supported,
    :claims_supported,
    :service_documentation,
    :claims_locales_supported,
    :ui_locales_supported,
    :claims_parameter_supported,
    :request_parameter_supported,
    :request_uri_parameter_supported,
    :require_request_uri_registration,
    :op_policy_uri,
    :op_tos_uri,
    :revocation_endpoint,
    :revocation_endpoint_auth_methods_supported,
    :revocation_endpoint_auth_signing_alg_values_supported,
    :introspection_endpoint,
    :introspection_endpoint_auth_methods_supported,
    :introspection_endpoint_auth_signing_alg_values_supported,
    :code_challenge_methods_supported,
    :end_session_endpoint,
    :require_pushed_authorization_requests,
    :pushed_authorization_request_endpoint,
    :authorization_response_iss_parameter_supported,
    :authorization_signing_alg_values_supported,
    :authorization_encryption_alg_values_supported,
    :authorization_encryption_enc_values_supported,
    :dpop_signing_alg_values_supported,
    :require_signed_request_object,
    :mtls_endpoint_aliases,
    :tls_client_certificate_bound_access_tokens,
    :extra_fields
  ]

  @type t() :: %__MODULE__{
          issuer: :uri_string.uri_string(),
          authorization_endpoint: :uri_string.uri_string(),
          token_endpoint: :uri_string.uri_string() | :undefined,
          userinfo_endpoint: :uri_string.uri_string() | :undefined,
          jwks_uri: :uri_string.uri_string() | :undefined,
          registration_endpoint: :uri_string.uri_string() | :undefined,
          scopes_supported: [String.t()] | :undefined,
          response_types_supported: [String.t()],
          response_modes_supported: [String.t()],
          grant_types_supported: [String.t()],
          acr_values_supported: [String.t()] | :undefined,
          subject_types_supported: [:pairwise | :public],
          id_token_signing_alg_values_supported: [String.t()],
          id_token_encryption_alg_values_supported: [String.t()] | :undefined,
          id_token_encryption_enc_values_supported: [String.t()] | :undefined,
          userinfo_signing_alg_values_supported: [String.t()] | :undefined,
          userinfo_encryption_alg_values_supported: [String.t()] | :undefined,
          userinfo_encryption_enc_values_supported: [String.t()] | :undefined,
          request_object_signing_alg_values_supported: [String.t()] | :undefined,
          request_object_encryption_alg_values_supported: [String.t()] | :undefined,
          request_object_encryption_enc_values_supported: [String.t()] | :undefined,
          token_endpoint_auth_methods_supported: [String.t()],
          token_endpoint_auth_signing_alg_values_supported: [String.t()] | :undefined,
          display_values_supported: [String.t()] | :undefined,
          claim_types_supported: [:normal | :aggregated | :distributed],
          claims_supported: [String.t()] | :undefined,
          service_documentation: :uri_string.uri_string() | :undefined,
          claims_locales_supported: [String.t()] | :undefined,
          ui_locales_supported: [String.t()] | :undefined,
          claims_parameter_supported: boolean(),
          request_parameter_supported: boolean(),
          request_uri_parameter_supported: boolean(),
          require_request_uri_registration: boolean(),
          op_policy_uri: :uri_string.uri_string() | :undefined,
          op_tos_uri: :uri_string.uri_string() | :undefined,
          revocation_endpoint: :uri_string.uri_string() | :undefined,
          revocation_endpoint_auth_methods_supported: [String.t()],
          revocation_endpoint_auth_signing_alg_values_supported: [String.t()] | :undefined,
          introspection_endpoint: :uri_string.uri_string() | :undefined,
          introspection_endpoint_auth_methods_supported: [String.t()],
          introspection_endpoint_auth_signing_alg_values_supported: [String.t()] | :undefined,
          code_challenge_methods_supported: [String.t()] | :undefined,
          end_session_endpoint: :uri_string.uri_string() | :undefined,
          require_pushed_authorization_requests: boolean(),
          pushed_authorization_request_endpoint: :uri_string.uri_string() | :undefined,
          authorization_response_iss_parameter_supported: boolean(),
          authorization_signing_alg_values_supported: [String.t()] | :undefined,
          authorization_encryption_alg_values_supported: [String.t()] | :undefined,
          authorization_encryption_enc_values_supported: [String.t()] | :undefined,
          dpop_signing_alg_values_supported: [String.t()] | :undefined,
          require_signed_request_object: boolean(),
          mtls_endpoint_aliases: %{binary() => :uri_string.uri_string()},
          tls_client_certificate_bound_access_tokens: boolean(),
          extra_fields: %{String.t() => term()}
        }
end