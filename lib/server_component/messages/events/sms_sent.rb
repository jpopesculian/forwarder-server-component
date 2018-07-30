module ServerComponent
  module Messages
    module Events
      class SmsSent
        include Messaging::Message

        attribute :request_id, String
        attribute :sms_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :from, String
        attribute :to, String
        attribute :body, String
        attribute :status_callback, String
      end
    end
  end
end
