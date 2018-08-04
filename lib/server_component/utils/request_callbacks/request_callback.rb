module ServerComponent
  module Utils
    module RequestCallbacks
      module RequestCallback
        def self.included(cls)
          cls.class_exec do
            include Messaging::StreamName
            include Messages::Events

            extend Build
            extend Configure
            extend ProcessingEventType

            category :server

            dependency :write, Messaging::Postgres::Write
            dependency :clock, Clock::UTC
          end
        end

        def configure
          Messaging::Postgres::Write.configure(self)
          Clock::UTC.configure(self)
        end

        def call(message)
          request_id = message.request_id
          stream_name = stream_name(request_id)
          time = clock.iso8601
          position = message.metadata.global_position

          processing_event = processing_event_type.follow(message, copy: [:request_id])
          processing_event.processed_time = time
          processing_event.meta_position = position

          write.(processing_event, stream_name)
        end

        def processing_event_type
          self.class.get_processing_event_type
        end

        module Configure
          def configure(receiver, attr_name: nil)
            attr_name ||= @default_attr_name
            instance = build
            receiver.public_send("#{attr_name}=", instance)
          end

          def default_attr_name(name)
            @default_attr_name = name
          end
        end

        module ProcessingEventType
          def processing_event_type(cls)
            @processing_event_type = cls
          end

          def get_processing_event_type
            @processing_event_type
          end
        end

        module Build
          def build
            instance = new
            instance.configure
            instance
          end
        end
      end
    end
  end
end
