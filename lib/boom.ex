defmodule Boom do
  defmacro __using__(notifiers_config) do
    quote location: :keep do
      import Boom

      use Plug.ErrorHandler

      defp handle_errors(_conn, %{reason: reason, stack: stack}) do
        try do
          for [notifier: notifier, options: options] <- unquote(notifiers_config) do
            payload = notifier.create_payload(reason, stack, options)
            notifier.notify(payload)
          end
        rescue
          e -> IO.inspect(e, label: "[Boom] Error sending exception")
        end
      end
    end
  end
end
