module ServerComponent
  module Messages
    module Commands
      class SmsReceive
        include Messaging::Message

        attribute :request_id, String
        attribute :sms_id, String
        attribute :message_sid, String
        attribute :time, String
      end
    end
  end
end
