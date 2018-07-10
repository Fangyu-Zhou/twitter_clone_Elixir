defmodule TwitterClient do
  def register(account, password) do
      url = "http://localhost:4000/register"
      {a, b} = RSA.generate_rsa()
      #      priv = RSA.decode_key(a)
      #      pub = RSA.decode_key(b)
      body = Poison.encode!(%{
        "account": account,
        "password": password,
        "publickeys": b
      })
      headers = [{"Content-type", "application/json"}]
      HTTPoison.post(url, body, headers, [])
      SignWebSocket.connect(account, a)
  end
end
