module ServerComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :clock, Clock::UTC
      dependency :sms_store, Sms::Store

      def configure
        Clock::UTC.configure(self)
        Sms::Store.configure(self, attr_name: :sms_store)
      end

      category :server

      handle SmsReceived do |sms_received|
        sms = sms_store.get(sms_received.sms_id)
        Models::Text::Receive.(sms)
      end

      handle SmsSent do |sms_sent|
        sms = sms_store.get(sms_sent.sms_id)
        Models::Text::Send.(sms)
      end
    end
  end
end
