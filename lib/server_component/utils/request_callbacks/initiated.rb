module ServerComponent
  module Utils
    module RequestCallbacks
      class Initiated
        include RequestCallback

        default_attr_name :initiated
        processing_event_type RequestInitiated
      end
    end
  end
end
