# Start the ExChromaDb child specs for testing
# This ensures that the Cachex cache is available during tests
{:ok, _} = Application.ensure_all_started(:cachex)

# Start the ExChromaDb cache supervision tree
# The child_specs function returns a nested list, so we flatten it
child_specs = ExChromaDb.child_specs()

# Start a supervisor to manage the cache processes
{:ok, _pid} = Supervisor.start_link(child_specs, strategy: :one_for_one)

ExUnit.start()
