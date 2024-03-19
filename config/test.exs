import Config

config :shin_auth,
  oidc_discovery_data_req_options: [
    plug: {Req.Test, ShinAuth.OIDC.ProviderConfiguration}
  ],
  oidc_is_endpoint_reachable_req: [
    plug: {Req.Test, ShinAuth.OIDC.ProviderConfiguration}
  ]
