require_relative './client_exercise_init'

message_sid = "SM167c72b00640f6f1885b34960e16c568"

command = Server::Client::SmsSend.(
  body: 'hello',
  to: '+19165854267',
  from: '+14158542955'
)

ForwarderHost::Start.()
