module ServerComponent
  module Commands
    class SmsSend
      include Command

      default_attr_name :sms_send

      def self.call(body:, to:, from:, request_id: nil, callback_root: nil, sms_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        instance = self.build
        instance.(
          request_id: request_id,
          sms_id: sms_id,
          to: to,
          body: body,
          time: time,
          from: from,
          callback_root: callback_root,
          reply_stream_name: reply_stream_name,
          previous_message: previous_message
        )
      end

      def call(body:, to:, from:, request_id: nil, callback_root: nil, sms_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        sms_id ||= Identifier::UUID::Random.get
        request_id ||= Identifier::UUID::Random.get
        time ||= Clock::UTC.iso8601
        status_callback = callback_root.nil? ? nil : "#{callback_root}/#{sms_id}"

        sms_send = self.class.build_message(Messages::Commands::SmsSend, previous_message)

        sms_send.request_id = request_id
        sms_send.sms_id = sms_id
        sms_send.time = time
        sms_send.to = to
        sms_send.from = from
        sms_send.body = body
        sms_send.status_callback = status_callback

        stream_name = command_stream_name(request_id)

        write.(sms_send, stream_name, reply_stream_name: reply_stream_name)

        sms_send
      end
    end
  end
end
