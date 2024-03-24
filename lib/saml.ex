defmodule ShinAuth.SAML do
  @moduledoc """
  Security Assertion Markup Language utilities.
  """

  alias ShinAuth.SAML.Request

  #   XML binary =>
  # Saxy (to create a SimpleForm DOM) =>
  #   Query that DOM with DataSchema =>
  #     Struct

  def decode_saml_request do
    source_data = """
    <Blog date="2021-11-11" time="14:00:00">
      <Content>This is a blog post</Content>
      <Comments>
        <Comment>This is a comment</Comment>
        <Comment>This is another comment</Comment>
      </Comments>
      <Draft>
        <Content>This is a draft blog post</Content>
      </Draft>
    </Blog>
    """

    DataSchema.to_struct(source_data, Request)
  end
end
