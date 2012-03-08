require 'bells/syntax/node'

class Bells::Syntax::Node::Symbol < Bells::Syntax::Node
  
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
  
  def to_s
    symbol.inspect
  end
end