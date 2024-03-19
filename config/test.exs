import Config

config :shin_auth,
  oidc_discovery_data_req_options: [
    plug: {Req.Test, ShinAuth.OIDC.ProviderConfiguration}
  ],
  oidc_reach_metadata_endpoint_req: [
    plug: {Req.Test, ShinAuth.OIDC.ProviderConfiguration}
  ]
