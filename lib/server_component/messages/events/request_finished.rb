module ServerComponent
  module Messages
    module Events
      class RequestInitiated
        include Messaging::Message

        attribute :request_id, String
        attribute :processed_time, String
        attribute :meta_position, Integer
      end
    end
  end
end
