require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::False < Bells::Runtime::Macro::Object

  def bells_init_env env
    env[:to_s] = bells_value "(false)"
    env[:nil?] = env[:true]
  end
  
  def bells_condition
    false
  end
  
end
