module ServerComponent
  module Handlers
    class Replies
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName

      # include Sms::Client::Messages::Replies
      include Messages::Events

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC

      def configure
        Messaging::Postgres::Write.configure(self)
        Clock::UTC.configure(self)
      end

      category :server
    end
  end
end
