defmodule ShinAuth.OIDC.ProviderConfiguration.Error do
  @type t :: %__MODULE__{
          tag: atom(),
          message: String.t()
        }

  defexception [:tag, :message]

  def message(%{tag: _tag, message: message}) do
    message
  end
end
