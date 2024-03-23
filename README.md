# Shin

🍀 A collection of lightweight auth utilities for Elixir. 


## Introduction

**Shin** **信** means "trust", "faith", or "belief" in Japanese. 

This package aims to provide lightweight utilities that can be used to ensure that primitives are well validated and trusted for usage by auth providers. 

## Getting started 

The package can be installed by adding `shin_auth` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:shin_auth, "~> 0.1.0"}
  ]
end
```

## Utilities per protocol 

### OpenID Connect (OIDC)

#### `load_provider_configuration` 

Based on the spec: https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata

Loads, validates and parses the Identity Provider configuration based on their discovery endpoint metadata. 

With valid configuration, returns parsed metadata:
```ex
iex(1)> ShinAuth.OIDC.load_provider_configuration("https://valid-url/.well-known/openid-configuration")
{:ok, %ShinAuth.OIDC.ProviderConfiguration.Metadata{}}
```

With invalid configuration, returns error:

```ex
iex(1)> ShinAuth.OIDC.load_provider_configuration("https://invalid-discovery/.well-known/openid-configuration")
{:error, %ShinAuth.OIDC.ProviderConfiguration.Error{}}
```

Here's a list of error per tags:

| Tags                                | Reason                                                                 |
|------------------------------------|------------------------------------------------------------------------|
| `malformed_discovery_endpoint` or `discovery_endpoint_unreachable`      | The provided endpoint is either malformed or unreachable via HTTP request       |
| `authorization_endpoint_unreachable` | `authorization_code` is unreachable via HTTP request |
| `token_endpoint_unreachable`       |  `token_endpoint` is unreachable via HTTP request           |
| `jwks_uri_unreachable` or `malformed_jwks_uri_response`       | `jwks_uri` is either unreachable via HTTP request or the response is malformed |
| `missing_issuer_attribute`         | `issuer` attribute is missing from the provider's metadata |


### Security Assertion Markup Language (SAML) 

### `decode_saml_response`

Work in progress.

### `decode_saml_request`

Work in progress.
