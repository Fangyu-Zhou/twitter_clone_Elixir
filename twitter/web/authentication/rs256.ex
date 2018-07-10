defmodule RS256 do
    def generate_secret_key(account) do
        Base.encode16(:crypto.hash(:sha256, account))
    end

    def encode(json, hs256_key) do
        options = %{key: hs256_key}
        JsonWebToken.sign(json, options)
    end

    def decode(jwt, hs256_key) do
        options = %{key: hs256_key}
        {:ok, verified_claims} = JsonWebToken.verify(jwt, options)
        verified_claims
    end
end