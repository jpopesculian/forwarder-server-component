module ServerComponent
  module Triggers
    class MessageFetchedTrigger
      include Trigger

      default_attr_name :message_fetched_trigger
      subscription_name :message_fetched
    end
  end
end
