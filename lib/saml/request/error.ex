defmodule ShinAuth.SAML.Request.Error do
  @moduledoc """
  Defines the possible errors from decoding a SAML request
  """

  @type t :: %__MODULE__{
          tag: :malformed_saml_request,
          message: String.t()
        }

  defexception [:tag, :message]

  def message(%{tag: _tag, message: message}) do
    message
  end
end
