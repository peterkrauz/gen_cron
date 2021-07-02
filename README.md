# Gen.Cron

A CRON-like GenServer stub generator.

## Installation

If [available in Hex](https://hex.pm/packages/gen_cron), the package can be installed
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
$ mix gen.cron --name MyRoutine --recurrence 2 --period hour
```

This will generate an Elixir file called `my_routine.ex` inside `lib/routines`. The file will contain a skeleton of a CRON-like GenServer, whose schedule will be set to the milliseconds provided by your input. In this case, 2 hours.

The following period arguments are available:
- `second` 
- `minute` 
- `hour`   
- `day`    
- `week`

## Example
To create a GenServer routine that should run every 5 minutes sending push notifications to a mobile app:
```
$ mix gen.cron --name NotifyMobileUsers --recurrence 5 --period minute
```

Don't forget to add your newly-created GenServer to your list of supervised processes, usually found on `lib/<your_project>/application.ex`, like so:

```elixir

use Application

def start(_type, _args) do
  children = [
    ...
    Routines.NotifyMobileUsers
  ]

  opts = [strategy: :one_for_one, name: YourProject.Supervisor]
  Supervisor.start_link(children, opts)

```