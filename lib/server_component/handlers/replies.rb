module ServerComponent
  module Handlers
    class Replies
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName

      include Sms::Client::Messages::Replies
      include Messages::Events

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC

      def configure
        Messaging::Postgres::Write.configure(self)
        Clock::UTC.configure(self)
      end

      category :server

      handle RecordSmsReceived do |record_sms_received|
        source_message_stream_name = record_sms_received.metadata.source_message_stream_name
        request_id = Messaging::StreamName.get_id(source_message_stream_name)

        sms_received = SmsReceived.follow(record_sms_received)
        sms_received.request_id = request_id

        stream_name = stream_name(request_id)
        write.(sms_received, stream_name)
      end

      handle RecordSmsSent do |record_sms_sent|
        source_message_stream_name = record_sms_sent.metadata.source_message_stream_name
        request_id = Messaging::StreamName.get_id(source_message_stream_name)

        sms_sent = SmsSent.follow(record_sms_sent)
        sms_sent.request_id = request_id

        stream_name = stream_name(request_id)
        write.(sms_sent, stream_name)
      end
    end
  end
end
