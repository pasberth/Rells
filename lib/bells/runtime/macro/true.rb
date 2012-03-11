require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::True < Bells::Runtime::Macro::Object
  
  def bells_init_env env
    env[:to_s] = bells_value "(true)"
    env[:nil?] = env[:false]
  end
end