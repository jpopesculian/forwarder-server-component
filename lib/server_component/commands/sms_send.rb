module ServerComponent
  module Commands
    class SmsSend
      include Command

      default_attr_name :sms_send

      def self.call(body:, to:, from:, sms_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        instance = self.build
        instance.(
          sms_id: sms_id,
          to: to,
          body: body,
          time: time,
          from: from,
          reply_stream_name: reply_stream_name,
          previous_message: previous_message
        )
      end

      def call(body:, to:, from:, sms_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        sms_id ||= Identifier::UUID::Random.get
        time ||= Clock::UTC.iso8601

        sms_send = self.class.build_message(Messages::Commands::SmsSend, previous_message)

        sms_send.sms_id = sms_id
        sms_send.time = time
        sms_send.to = to
        sms_send.from = from
        sms_send.body = body

        stream_name = command_stream_name(sms_id)

        write.(sms_send, stream_name, reply_stream_name: reply_stream_name)

        sms_send
      end
    end
  end
end
