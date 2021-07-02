# Gen.Cron

A CRON-like GenServer stub generator.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `gen_cron` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gen_cron, "~> 0.1.0"}
  ]
end
```

After updating your list of dependencies, install and compile them with:

```
$ mix do deps.get, deps.compile
```

## Usage
From the root folder of your mix project, run the following command:

```
mix gen.cron --name MyRoutine --recurrence 2 --period hour
```

This will generate an Elixir file called `my_routine.ex` inside `lib/routines`. The file will contain a skeleton of a CRON-like GenServer, whose schedule will be set to the milliseconds provided by your input. In this case, 2 hours.

The following period arguments are available:

| Period | 
|:------:|
| second |
| minute |
| hour   |
| day    |
| week   |


Don't forget to add your newly-created GenServer to your list of supervised processes, usually found on `lib/<your_project>/application.ex`, like so:

```diff

use Application

def start(_type, _args) do
  children = [
    ...
+   Routines.MyRoutine
  ]

  opts = [strategy: :one_for_one, name: YourProject.Supervisor]
  Supervisor.start_link(children, opts)

```