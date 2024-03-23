defmodule ShinAuth.OIDC.ProviderConfiguration.Error do
  @type t :: %__MODULE__{
          tag: atom(),
          message: String.t(),
          data: any() | nil,
          endpoint: String.t() | nil
        }

  defexception [:tag, :message, :data, :endpoint]

  def message(%{tag: _tag, data: _data, endpoint: _endpoint, message: message}) do
    message
  end
end
