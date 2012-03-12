require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::True < Bells::Runtime::Macro::Object
  
  def init_env env
    super
    env[:to_s] = create_a Macro::String, "(true)"
    env[:nil?] = env[:false]
  end
end