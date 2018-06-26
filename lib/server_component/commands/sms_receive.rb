module ServerComponent
  module Commands
    class SmsReceive
      include Command

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :sms_receive
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.call(message_sid:, time: nil, reply_stream_name: nil, previous_message: nil)
        time ||= Clock::UTC.iso8601
        instance = self.build
        instance.(
          message_sid: message_sid,
          time: time,
          reply_stream_name: reply_stream_name,
          previous_message: previous_message
        )
      end

      def call(message_sid:, time:, reply_stream_name: nil, previous_message: nil)
        sms_receive = self.class.build_message(Messages::Commands::SmsReceive, previous_message)

        sms_receive.message_sid = message_sid
        sms_receive.time = time

        stream_name = command_stream_name(message_sid)

        write.(sms_receive, stream_name, reply_stream_name: reply_stream_name)

        sms_receive
      end
    end
  end
end
