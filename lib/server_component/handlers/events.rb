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
      dependency :message_fetched_trigger, Triggers::MessageFetchedTrigger

      def configure
        Clock::UTC.configure(self)
        Sms::Store.configure(self, attr_name: :sms_store)
        Triggers::MessageFetchedTrigger.configure(self)
      end

      category :server

      handle SmsReceived do |sms_received|
        sms = sms_store.get(sms_received.sms_id)
        # TODO convert model functions into dependency objects
        text = Models::Text::Receive.(sms)
        message_fetched_trigger.(text)
      end

      handle SmsSent do |sms_sent|
        sms = sms_store.get(sms_sent.sms_id)
        Models::Text::Send.(sms)
      end
    end
  end
end
