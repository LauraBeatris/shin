defmodule ShinAuth.SAML.Response do
  @moduledoc """
  Parsed XML struct of a SAML response
  """

  @type t ::
          {:common, ShinAuth.SAML.Response.Common.t()}
          | {:conditions, ShinAuth.SAML.Response.Conditions.t()}

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Response.Utils

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(
    has_one: {:common, "/saml2p:Response", ShinAuth.SAML.Response.Common},
    has_one: {:status, "/saml2p:Response/saml2p:Status", ShinAuth.SAML.Response.Status},
    has_one:
      {:conditions, "/saml2p:Response/saml2:Assertion/saml2:Conditions",
       ShinAuth.SAML.Response.Conditions},
    has_many:
      {:attributes, "/saml2p:Response/saml2:Assertion/saml2:AttributeStatement/saml2:Attribute",
       ShinAuth.SAML.Response.Attribute}
  )
end

defmodule ShinAuth.SAML.Response.Common do
  @moduledoc false

  @type t ::
          {:id, String.t()}
          | {:version, String.t()}
          | {:destination, String.t()}
          | {:issuer, String.t()}
          | {:issue_instant, String.t()}

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Response.Utils

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(
    field: {:id, "./@ID", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field: {:version, "./@Version", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field: {:destination, "./@Destination", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:issuer, "./saml2p:Issuer/text()", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field: {:issue_instant, "./@IssueInstant", &{:ok, Utils.maybe_to_string(&1)}, optional: false}
  )
end

defmodule ShinAuth.SAML.Response.Conditions do
  @moduledoc false

  @type t ::
          {:not_before, String.t()}
          | {:not_on_or_after, String.t()}

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Response.Utils

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(
    field: {:not_before, "./@NotBefore", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:not_on_or_after, "./@NotOnOrAfter", &{:ok, Utils.maybe_to_string(&1)}, optional: false}
  )
end

defmodule ShinAuth.SAML.Response.Status do
  @moduledoc false

  @type t ::
          {:status, :failure, :successful}
          | {:status_code, String.t()}

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Response.Utils

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(
    field:
      {:status, "./saml2p:StatusCode/@Value", &{:ok, Utils.map_status_code_value(&1)},
       optional: false},
    field:
      {:status_code, "./saml2p:StatusCode/@Value", &{:ok, Utils.maybe_to_string(&1)},
       optional: false}
  )
end

defmodule ShinAuth.SAML.Response.Attribute do
  @moduledoc false

  @type t ::
          {:name, String.t()}
          | {:value, String.t()}

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Response.Utils

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(
    field: {:name, "./@Name", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:value, "./saml2:AttributeValue/text()", &{:ok, to_string(&1) |> String.trim()},
       optional: true}
  )
end

defmodule ShinAuth.SAML.Response.Utils do
  @moduledoc false

  def maybe_to_string(""), do: nil
  def maybe_to_string(nil), do: nil
  def maybe_to_string(value), do: to_string(value) |> String.trim()

  def map_status_code_value(value) do
    case value do
      "urn:oasis:names:tc:SAML:2.0:status:Success" -> :success
      _ -> :failure
    end
  end
end
