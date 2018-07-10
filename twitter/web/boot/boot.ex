defmodule MyApp.CLI do
    require Logger
    def main(args) do
        Logger.info "Hello from MyApp!"
        args |> run(1)
    end

    defp run(args, n) when n > 0 do
        spawn(UserOperation, :operate, args)

        run(args, n - 1)
    end

    defp run(args, n) do
        run(args, n)
    end

end