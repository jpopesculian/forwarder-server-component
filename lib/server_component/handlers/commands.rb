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
      dependency :initiated, Utils::RequestCallbacks::Initiated
      dependency :processed, Utils::Processed
      dependency :clock, Clock::UTC

      def configure
        Sms::Client::SmsForward.configure(self)
        Sms::Client::SmsDeliver.configure(self)
        Clock::UTC.configure(self)
        Utils::Processed.configure(self)
        Utils::RequestCallbacks::Initiated.configure(self)
      end

      category :server

      handle SmsReceive do |sms_receive|
        current, ignored = processed.(sms_receive)
        return ignored.() if current

        reply_stream_name = command_stream_name(sms_receive.request_id)

        sms_forward.(
          sms_id: sms_receive.sms_id,
          message_sid: sms_receive.message_sid,
          time: sms_receive.time,
          reply_stream_name: reply_stream_name,
          previous_message: sms_receive
        )
        initiated.(sms_receive)
      end

      handle SmsSend do |sms_send|
        current, ignored = processed.(sms_send)
        return ignored.() if current

        reply_stream_name = command_stream_name(sms_send.request_id)

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
        initiated.(sms_deliver)
      end
    end
  end
end
