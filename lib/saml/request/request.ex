defmodule ShinAuth.SAML.Request do
  @type t :: %__MODULE__{
          issuer: String.t()
        }

  defstruct [:issuer]
end
