defmodule ShinAuth.SAML.Response do
  @moduledoc """
  Parsed XML struct of a SAML response
  """

  import DataSchema, only: [data_schema: 1]

  alias ShinAuth.SAML.Response.Utils

  @data_accessor ShinAuth.SAML.XMLHandler
  data_schema(
    field: {:id, "/saml2p:Response/@ID", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:version, "/saml2p:Response/@Version", &{:ok, Utils.maybe_to_string(&1)}, optional: false},
    field:
      {:destination, "/saml2p:Response/@Destination", &{:ok, Utils.maybe_to_string(&1)},
       optional: false},
    field:
      {:issuer, "/saml2p:Response/saml2p:Issuer/text()", &{:ok, Utils.maybe_to_string(&1)},
       optional: false},
    field:
      {:issue_instant, "/saml2p:Response/@IssueInstant", &{:ok, Utils.maybe_to_string(&1)},
       optional: false}
  )
end

defmodule ShinAuth.SAML.Response.Utils do
  @moduledoc false

  def maybe_to_string(""), do: nil
  def maybe_to_string(nil), do: nil
  def maybe_to_string(value), do: to_string(value) |> String.trim()
end
