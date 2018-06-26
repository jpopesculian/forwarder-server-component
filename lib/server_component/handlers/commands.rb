module ServerComponent
  module Handlers
    class Commands
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :sms_forward, Sms::Client::SmsForward
      dependency :clock, Clock::UTC

      def configure
        Sms::Client::SmsForward.configure(self)
        Clock::UTC.configure(self)
      end

      category :server

      handle SmsReceive do |sms_receive|
        message_sid = sms_receive.message_sid
        time = clock.iso8601
        reply_stream_name = command_stream_name(message_sid)

        sms_forward.(
          message_sid: message_sid,
          time: time,
          reply_stream_name: reply_stream_name,
          previous_message: sms_receive
        )
      end
    end
  end
end
