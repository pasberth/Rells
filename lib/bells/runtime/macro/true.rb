require 'bells/runtime/macro'

class Bells::Runtime::Macro::True < Bells::Runtime::Macro::Object
  
  def init_env
    super
    self[var :to_s] = create_a Macro::String, "(true)"
    self[var :nil?] = self
  end
  
  def condition
    true
  end
end