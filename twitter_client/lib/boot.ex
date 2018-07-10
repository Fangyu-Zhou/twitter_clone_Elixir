defmodule MyApp.CLI do
    require Logger
    def main(args) do
        Logger.info "Hello from MyApp!"
        args |> run(Application.get_env(:elixir_server, :user_number, 5000))
    end

    defp run(args, n) when n > 0 do
        spawn(SignWebSocket, :connect, [Integer.to_string(n)])

        run(args, n - 1)
    end

    defp run(args, n) do
        IO.puts("finished")
        run(args, n)
    end

end