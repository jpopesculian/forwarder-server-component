module ServerComponent
  module Messages
    module Commands
      class SmsSend
        include Messaging::Message

        attribute :sms_id, String
        attribute :time, String
        attribute :to, String
        attribute :body, String
        attribute :from, String
      end
    end
  end
end
