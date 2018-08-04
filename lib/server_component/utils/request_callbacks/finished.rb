module ServerComponent
  module Utils
    module RequestCallbacks
      class Finished
        include RequestCallback

        default_attr_name :finished
        processing_event_type RequestFinished
      end
    end
  end
end
