require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::Nil < Bells::Runtime::Macro::Object

  def bells_init_env env
    super

    env[:to_s] = bells_value "(nil)"
    env[:nil?] = env[:true]
  end

  def bells_condition
    false
  end

end