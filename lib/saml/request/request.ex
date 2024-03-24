defmodule DraftPost do
  import DataSchema, only: [data_schema: 1]

  @data_accessor ShinAuth.SAML.Request.XMLHandler
  data_schema(field: {:content, "./Content/text()", fn value -> {:ok, value} end})
end

defmodule Comment do
  import DataSchema, only: [data_schema: 1]

  @data_accessor ShinAuth.SAML.Request.XMLHandler
  data_schema(field: {:text, "./text()", &{:ok, to_string(&1)}})
end

defmodule ShinAuth.SAML.Request do
  import DataSchema, only: [data_schema: 1]

  @data_accessor ShinAuth.SAML.Request.XMLHandler
  @datetime_fields [
    field: {:date, "/Blog/@date", &Date.from_iso8601/1},
    field: {:time, "/Blog/@time", &Time.from_iso8601/1}
  ]
  data_schema(
    field: {:content, "/Blog/Content/text()", &{:ok, to_string(&1)}},
    has_many: {:comments, "//Comment", Comment},
    has_one: {:draft, "/Blog/Draft", DraftPost},
    aggregate: {:post_datetime, @datetime_fields, &NaiveDateTime.new(&1.date, &1.time)}
  )
end
