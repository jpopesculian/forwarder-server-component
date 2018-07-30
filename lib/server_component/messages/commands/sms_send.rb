module ServerComponent
  module Messages
    module Commands
      class SmsSend
        include Messaging::Message

        attribute :request_id, String
        attribute :sms_id, String
        attribute :time, String
        attribute :to, String
        attribute :body, String
        attribute :from, String
        attribute :status_callback, String
      end
    end
  end
end
