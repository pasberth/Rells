require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::Nil < Bells::Runtime::Macro::Object

  def init_env env
    super

    env[:to_s] = create_a Macro::String, "(nil)"
    env[:nil?] = env[:true]
  end

  def condition
    false
  end

end