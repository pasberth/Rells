require 'bells/runtime/macro'

class Bells::Runtime::Macro::Nil < Bells::Runtime::Macro::Object

  def init_env
    super
    self[var :to_s] = create_a Macro::String, "(nil)"
    self[var :nil?] = self
  end

  def condition
    false
  end

end