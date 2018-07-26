module ServerComponent
  module Handlers
    class Commands
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :sms_forward, Sms::Client::SmsForward
      dependency :sms_deliver, Sms::Client::SmsForward
      dependency :clock, Clock::UTC

      def configure
        Sms::Client::SmsForward.configure(self)
        Sms::Client::SmsDeliver.configure(self)
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

      handle SmsSend do |sms_send|
        sms_id = sms_send.sms_id
        reply_stream_name = command_stream_name(sms_id)

        sms_deliver.(
          sms_id: sms_send.sms_id,
          to: sms_send.to,
          from: sms_send.from,
          time: sms_send.time,
          body: sms_send.body,
          status_callback: sms_send.status_callback,
          reply_stream_name: reply_stream_name,
          previous_message: sms_send
        )
      end
    end
  end
end
