module ServerComponent
  class Projection
    include EntityProjection
    include Messages::Events

    entity_name :request

    apply RequestInitiated do |initiated|
      request.id = initiated.request_id
      request.start_time = Time.parse(initiated.processed_time)
      request.meta_position = initiated.meta_position
    end

    apply RequestFinished do |finished|
      request.id = finished.request_id
      request.finish_time = Time.parse(finished.processed_time)
      request.meta_position = finished.meta_position
    end
  end
end
