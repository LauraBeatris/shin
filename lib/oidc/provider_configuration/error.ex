defmodule ShinAuth.OIDC.ProviderConfiguration.Error do
  @type t :: %__MODULE__{tag: atom(), severity: :error | :warning, message: String.t()}

  defexception [:tag, :severity, :message]

  def message(%{tag: _tag, severity: _severity, message: message}) do
    message
  end
end
