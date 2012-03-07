require 'bells/syntax/node'

class Bells::Syntax::Node::Symbol
  
  attr_reader :symbol

  def initialize symbol
    @symbol = symbol
  end
  
  def == other
    symbol == other.symbol
  rescue
    false
  end
end