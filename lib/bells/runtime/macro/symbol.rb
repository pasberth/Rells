require 'bells/runtime/macro'

class Bells::Runtime::Macro::Symbol < Bells::Runtime::Macro

  attr_reader :symbol

  def initialize symbol
    @symbol = symbol
  end
  
  def init_env
    self[var :to_s] = create_a Macro::Func do |_, *a| _.symbol.to_s end
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
