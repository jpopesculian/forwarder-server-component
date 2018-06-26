module ServerComponent
  module Start
    def self.call
      Consumers::Commands.start('server:command')
      Consumers::Events.start('server')
      Consumers::Replies.start('server:command')
    end
  end
end
