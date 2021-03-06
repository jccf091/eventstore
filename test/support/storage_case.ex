defmodule EventStore.StorageCase do
  use ExUnit.CaseTemplate

  alias EventStore.Config
  alias EventStore.Registration
  alias EventStore.Serializer
  alias EventStore.Storage

  @event_store TestEventStore

  setup_all do
    config = Config.parsed(@event_store, :eventstore)
    registry = Registration.registry(@event_store, config)
    serializer = Serializer.serializer(@event_store, config)
    postgrex_config = Config.default_postgrex_opts(config)

    {:ok, conn} = Postgrex.start_link(postgrex_config)

    [
      conn: conn,
      config: config,
      event_store: @event_store,
      postgrex_config: postgrex_config,
      registry: registry,
      serializer: serializer
    ]
  end

  setup %{conn: conn} do
    Storage.Initializer.reset!(conn)

    {:ok, _pid} = start_supervised({@event_store, name: @event_store})

    :ok
  end
end
