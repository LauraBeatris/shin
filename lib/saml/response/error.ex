defmodule ShinAuth.SAML.Response.Error do
  @moduledoc """
  Defines the possible errors from decoding a SAML response
  """

  @type t :: %__MODULE__{
          tag: :malformed_saml_response,
          message: String.t()
        }

  defexception [:tag, :message]

  def message(%{tag: _tag, message: message}) do
    message
  end
end
