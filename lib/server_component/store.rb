module ServerComponent
  class Store
    include EntityStore

    category :server
    entity Request
    projection Projection
    reader MessageStore::Postgres::Read
  end
end
