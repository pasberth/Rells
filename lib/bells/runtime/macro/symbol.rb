require 'bells/runtime/macro'

class Bells::Runtime::Macro::Symbol
  
  include Bells::Runtime::Macro
  
  attr_reader :symbol
  
  def to_rb
    @symbol
  end
  
  def to_s
    @symbol.to_s
  end
  
  def inspect
    @symbol.inspect
  end
  
  def initialize symbol
    @symbol = symbol
  end

  def bells_init_env env
    env[:to_s] = env.create_a Macro::Func, self do |_, f, *a|
      _.bells_value _.to_s
     end
  end
  
  def bells_eval *nodes
    bells_env.static_context.bells_env[self]
  end

  def eql? other
    symbol.eql? other.symbol
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
