module ServerComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :clock, Clock::UTC

      def configure
        Clock::UTC.configure(self)
      end

      category :server
    end
  end
end
