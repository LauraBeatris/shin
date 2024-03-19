# Shin

🍀 A collection of lightweight auth utilities for Elixir. 

## Introduction

**Shin** **信** means "trust", "faith", or "belief" in Japanese. 

This package aims to provide lightweight utilities that can be used to ensure that primitives are well validated and trusted for usage by auth providers. 

## Roadmap 

Work in progress. Those are the features ordered by priority: 

- [ ] OIDC discovery endpoint validator 
- [ ] SAML response validator
- [ ] SAML logout request validator 
- [ ] SAML logout response validator 

Infra:

- [ ] Configure CI for tests 

## Getting started 

The package can be installed by adding `shin_auth` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:shin_auth, "~> 0.1.0"}
  ]
end
```
