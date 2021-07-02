defmodule Mix.Tasks.Gen.Cron do
  @shortdoc "Creates a GenServer file with a CRON-like behavior"
  @file_path "lib/routines/"

  use Mix.Task

  def run(args) do
    {parsed_args, _} =
      OptionParser.parse!(
        args,
        switches: [period: String, recurrence: Integer, name: String]
      )

    args = parsed_args |> Enum.into(%{})
    create_routine_file(args)
    notify_user_to_add_routine_to_supervisor(args[:name])
  end

  defp create_routine_file(args) do
    routine_delay = args |> parse_routine_delay()
    %{period: period, recurrence: recurrence, name: name} = args

    with :ok <- File.mkdir_p!(Path.dirname(@file_path)) do
      write_routine_file(routine_delay, period, recurrence, name)
    end
  end

  defp parse_routine_delay(args) do
    {recurrence, _} = Integer.parse(args[:recurrence])
    period = args[:period]

    period |> parse_to_seconds(recurrence)
  end

  defp write_routine_file(routine_delay, period, recurrence, name) do
    File.write(
      @file_path <> "#{Macro.underscore(name)}.ex",
      """
      defmodule Routines.#{name} do
        use GenServer

        def start_link(_) do
          GenServer.start_link(__MODULE__, %{})
        end

        @impl true
        def init(state) do
          schedule_work()

          {:ok, state}
        end

        @impl true
        def handle_info(:work, state) do
          # Do your work here

          schedule_work()

          {:noreply, state}
        end

        defp schedule_work() do
          # #{recurrence} #{period}(s) in milliseconds
          delay = #{routine_delay}
          Process.send_after(self(), :work, delay)
        end
      end
      """
    )
  end

  defp parse_to_seconds("second", recurrence), do: recurrence * 1000
  defp parse_to_seconds("minute", recurrence), do: parse_to_seconds("second", recurrence * 60)
  defp parse_to_seconds("hour", recurrence), do: parse_to_seconds("minute", recurrence * 60)
  defp parse_to_seconds("day", recurrence), do: parse_to_seconds("hour", recurrence * 24)
  defp parse_to_seconds("week", recurrence), do: parse_to_seconds("day", recurrence * 7)

  defp notify_user_to_add_routine_to_supervisor(routine_name) do
    Mix.shell().info("""

    Don't forget to add your routine to the list of supervised processes!

    #{IO.ANSI.magenta()}# lib/your_project/application.ex #{IO.ANSI.cyan()}
    def start(_type, _args) do
      children = [
        ...
        #{IO.ANSI.green()}Routines.#{routine_name}#{IO.ANSI.cyan()}
      ]
      ...
    end
    """)
  end
end
