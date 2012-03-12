
module Bells::Runtime::Global::EnvironmentVariables
  initial_load do |env|
    env[:"$LOAD_PATH"] = create_a(Macro::Array, [create_a(Macro::String, (::File.dirname(__FILE__) + '/../../../../../pure'))])
  end
end
