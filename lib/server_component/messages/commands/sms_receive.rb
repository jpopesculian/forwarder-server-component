module ServerComponent
  module Messages
    module Commands
      class SmsReceive
        include Messaging::Message

        attribute :message_sid, String
        attribute :time, String
      end
    end
  end
end
