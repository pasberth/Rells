require 'bells/runtime/macro'

class Bells::Runtime::Macro::Symbol < Bells::Runtime::Macro

  attr_reader :symbol

  def initialize symbol
    @symbol = symbol
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
