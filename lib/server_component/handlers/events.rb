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

      dependency :finished, Utils::RequestCallbacks::Finished
      dependency :processed, Utils::Processed

      dependency :message_fetched_trigger, Triggers::MessageFetchedTrigger

      dependency :text_receive, Models::Mutations::TextReceive
      dependency :text_send, Models::Mutations::TextSend

      def configure
        Clock::UTC.configure(self)
        Sms::Store.configure(self, attr_name: :sms_store)

        Utils::RequestCallbacks::Finished.configure(self)
        Utils::Processed.configure(self)

        Triggers::MessageFetchedTrigger.configure(self)

        Models::Mutations::TextReceive.configure(self)
        Models::Mutations::TextSend.configure(self)
      end

      category :server

      handle SmsReceived do |sms_received|
        sms = sms_store.get(sms_received.sms_id)
        text = text_receive.(sms)
        message_fetched_trigger.(text)

        current, ignored = processed.(sms_received)
        return ignored.() if current

        finished.(sms_received)
      end

      handle SmsSent do |sms_sent|
        sms = sms_store.get(sms_sent.sms_id)
        text = text_send.(sms)

        current, ignored = processed.(sms_sent)
        return ignored.() if current

        finished.(sms_sent)
      end
    end
  end
end
