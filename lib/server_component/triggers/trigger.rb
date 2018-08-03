module ServerComponent
  module Triggers
    module Trigger

      def self.included(cls)
        cls.class_exec do
          extend Build
          extend Configure
          extend SubscriptionName
          extend SplitOptions
        end
      end

      def call(data, options = {})
        trigger(subscription_name, data, options)
      end

      def subscription_name
        self.class.get_subscription_name
      end

      module SubscriptionName
        def subscription_name(name)
          @subscription_name = sanitize_name name
        end

        def get_subscription_name
          @subscription_name
        end

        def sanitize_name(name)
          name.to_s.split('_').collect(&:capitalize).join.tap { |s| s[0] = s[0].downcase }
        end
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

      module Build
        def build
          instance = new
          # instance.configure
          instance
        end
      end

      module SplitOptions
        def split_options(options)
          scope = options.slice(:scope)
          arguments = options.tap { |x| x.delete(:scope) }
          return arguments, scope
        end
      end

      private

      attr_reader :schema

      def subscriptions
        ForwarderSchema::Schema.subscriptions
      end

      def subscriptions?
        !subscriptions.nil?
      end

      def trigger(name, model, options = {})
        return false unless subscriptions?
        arguments, scope = self.class.split_options(options)
        subscriptions.trigger(name, arguments, model, scope)
        return true
      end
    end
  end
end
