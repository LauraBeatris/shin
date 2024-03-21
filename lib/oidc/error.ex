defmodule ShinAuth.OIDC.Error do
  @type t :: %__MODULE__{message: String.t()}

  defexception [:message]
end
