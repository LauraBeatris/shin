defmodule ShinAuth.SAML.Request do
  @moduledoc """
  Parsed XML struct of a SAML Request
  """

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Request.Utils

  @type t ::
          {:id, String.t()}
          | {:version, String.t()}
          | {:assertion_consumer_service_url, String.t()}
          | {:issuer, String.t()}
          | {:issue_instant, String.t()}

  @data_accessor ShinAuth.SAML.Request.XMLHandler
  data_schema(
    field: {:id, "/samlp:AuthnRequest/@ID", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:version, "/samlp:AuthnRequest/@Version", &{:ok, Utils.maybe_to_string(&1)},
       optional: false},
    field:
      {:assertion_consumer_service_url, "/samlp:AuthnRequest/@AssertionConsumerServiceURL",
       &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:issuer, "/samlp:AuthnRequest/saml:Issuer/text()", &{:ok, Utils.maybe_to_string(&1)},
       optional: false},
    field:
      {:issue_instant, "/samlp:AuthnRequest/@IssueInstant", &{:ok, Utils.maybe_to_string(&1)},
       optional: false}
  )
end

defmodule ShinAuth.SAML.Request.Utils do
  @moduledoc false

  def maybe_to_string(""), do: nil
  def maybe_to_string(nil), do: nil
  def maybe_to_string(value), do: to_string(value) |> String.trim()
end
