defmodule RSA do
#         Decrypt using the private key
    def decrypt(cyphertext, {:private, key}) do
        cyphertext |> :public_key.decrypt_private key
    end

    # Decrypt using the public key
    def decrypt(cyphertext, {:public, key}) do
        cyphertext |> :public_key.decrypt_public key
    end

    # Encrypt using the private key
    def encrypt(text, {:private, key}) do
        text |> :public_key.encrypt_private key
    end

    # Encrypt using the public key
    def encrypt(text, {:public, key}) do
        text |> :public_key.encrypt_public key
    end

    # Decode a key from its text representation to a PEM structure
    def decode_key(text) do
        [entry] = text |> :public_key.pem_decode
        entry |> :public_key.pem_entry_decode
    end


    def generate_rsa do
        port = Port.open({:spawn, "OpenSSL/bin/openssl genrsa 2048"}, [:binary])
        priv_key_string
        =
                receive do
                    {^port, {:data, data}} ->
                        data
                end
        Port.close(port)
        [pem_entry] = :public_key.pem_decode(priv_key_string)
        pub_key = :public_key.pem_entry_decode(pem_entry) |> public_key
        pub_key_string = :public_key.pem_encode([:public_key.pem_entry_encode(:'RSAPublicKey', pub_key)])
        {priv_key_string, pub_key_string}
    end

    defp public_key({:RSAPrivateKey, _, modulus, public_exponent, _, _, _,_, _, _, _}) do
        { :RSAPublicKey, modulus, public_exponent }
    end
end