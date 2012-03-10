
module Bells::Runtime::Global::EnvironmentVariables
  initial_load do |env|
    env[:"$LOAD_PATH"] = bells_value [(::File.dirname(__FILE__) + '/../../../../../pure')]
  end
end
