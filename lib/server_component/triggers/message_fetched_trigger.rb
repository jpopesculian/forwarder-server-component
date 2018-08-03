module ServerComponent
  module Triggers
    class MessageFetchedTrigger
      include Trigger

      default_attr_name :message_fetched_trigger
      subscription_name :message_fetched

      def call(text)
        trigger(subscription_name, text.as_json, number: text.contact)
      end
    end
  end
end
