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
    {:shin_auth, "~> 1.1.0"}
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

Parsed a given SAML response to a struct with attributes and values: 

```ex
iex(1)> ShinAuth.SAML.decode_saml_response(saml_response_xml)

{:ok, %ShinAuth.SAML.Response{
   common: %ShinAuth.SAML.Response.Common{
     id: "_123",
     version: "2.0",
     destination: "https://api.example.com/sso/saml/acs/123",
     issuer: "https://example.com/1234/issuer/1234",
     issue_instant: "2024-03-23T20:56:56.768Z"
   },
   status: %ShinAuth.SAML.Response.Status{
     status: :success,
     status_code: "urn:oasis:names:tc:SAML:2.0:status:Success"
   },
   conditions: %ShinAuth.SAML.Response.Conditions{
     not_before: "2024-03-23T20:56:56.768Z",
     not_on_or_after: "2024-03-23T21:01:56.768Z"
   },
   attributes: [
     %ShinAuth.SAML.Response.Attribute{
       name: "id",
       value: "209bac63df9962e7ec458951607ae2e8ed00445a"
     },
     %ShinAuth.SAML.Response.Attribute{
       name: "email",
       value: "foo@corp.com"
     },
     %ShinAuth.SAML.Response.Attribute{
       name: "firstName",
       value: "Laura"
     },
     %ShinAuth.SAML.Response.Attribute{
       name: "lastName",
       value: "Beatris"
     },
     %ShinAuth.SAML.Response.Attribute{name: "groups", value: ""}
   ]
 }}
```

### `decode_saml_request`

Parsed a given SAML request to a struct with attributes and values: 

```ex
iex(1)> ShinAuth.SAML.decode_saml_request(saml_request_xml)

{:ok, %ShinAuth.SAML.Request{
   common: %ShinAuth.SAML.Request.Common{
     id: "_123",
     version: "2.0",
     assertion_consumer_service_url: "https://auth.example.com/sso/saml/acs/123",
     issuer: "https://example.com/123",
     issue_instant: "2023-09-27T17:20:42.746Z"
   }
 }}
```

