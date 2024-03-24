defmodule ShinAuth.SAML.Request do
  @moduledoc """
  Parsed XML struct of a SAML request
  """

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Request.Utils

  @type t ::
          {:common, ShinAuth.SAML.Request.Common.t()}

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(has_one: {:common, "/samlp:AuthnRequest", ShinAuth.SAML.Request.Common})
end

defmodule ShinAuth.SAML.Request.Common do
  @moduledoc """
  Defines the common attributes from `samlp:AuthnRequest`
  """

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Request.Utils

  @type t ::
          {:id, String.t()}
          | {:version, String.t()}
          | {:assertion_consumer_service_url, String.t()}
          | {:issuer, String.t()}
          | {:issue_instant, String.t()}

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(
    field: {:id, "./@ID", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field: {:version, "./@Version", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:assertion_consumer_service_url, "./@AssertionConsumerServiceURL",
       &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field: {:issuer, "./saml:Issuer/text()", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field: {:issue_instant, "./@IssueInstant", &{:ok, Utils.maybe_to_string(&1)}, optional: false}
  )
end

defmodule ShinAuth.SAML.Request.Utils do
  @moduledoc false

  def maybe_to_string(""), do: nil
  def maybe_to_string(nil), do: nil
  def maybe_to_string(value), do: to_string(value) |> String.trim()
end
