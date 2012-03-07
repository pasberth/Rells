require 'bells/runtime/macro'

class Bells::Runtime::Macro::Symbol < Bells::Runtime::Macro

  attr_reader :symbol

  def initialize symbol
    super
    @symbol = symbol
  end
  
  def init_env
    @env[var :to_s] = create_a Macro::Func, self do |_, *a|
       _.create_a Bells::Runtime::Macro::String, _.symbol.to_s
     end
  end
  
  def bells_eval *nodes
    @static_context[self].bells_eval *nodes
  end
  
  def eql? other
    @symbol.eql? other.symbol
  rescue
    false
  end
  
  def hash
    @symbol.hash
  end
  
  def == other
    symbol == other.symbol
  rescue
    false
  end
end
