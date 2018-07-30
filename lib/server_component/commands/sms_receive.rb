module ServerComponent
  module Commands
    class SmsReceive
      include Command

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :sms_receive
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.call(message_sid:, request_id: nil, sms_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        instance = self.build
        instance.(
          request_id: request_id,
          sms_id: sms_id,
          message_sid: message_sid,
          time: time,
          reply_stream_name: reply_stream_name,
          previous_message: previous_message
        )
      end

      def call(message_sid:, request_id: nil, sms_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        sms_id ||= Identifier::UUID::Random.get
        request_id ||= Identifier::UUID::Random.get
        time ||= Clock::UTC.iso8601

        sms_receive = self.class.build_message(Messages::Commands::SmsReceive, previous_message)

        sms_receive.request_id = request_id
        sms_receive.sms_id = sms_id
        sms_receive.message_sid = message_sid
        sms_receive.time = time

        stream_name = command_stream_name(request_id)

        write.(sms_receive, stream_name, reply_stream_name: reply_stream_name)

        sms_receive
      end
    end
  end
end
