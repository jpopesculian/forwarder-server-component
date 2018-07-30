module ServerComponent
  module Messages
    module Events
      class SmsReceived
        include Messaging::Message

        attribute :request_id, String
        attribute :sms_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :from, String
        attribute :to, String
        attribute :body, String
        attribute :direction, String
        attribute :status, String
      end
    end
  end
end
