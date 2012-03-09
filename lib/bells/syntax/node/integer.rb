require 'bells/syntax/node'

class Bells::Syntax::Node::Integer < Bells::Syntax::Node
  
  attr_reader :integer

  def initialize integer
    @integer = integer
  end
  
  def == other
    integer == other.integer
  rescue
    false
  end
  
  def to_s
    @integer.to_s
  end
end
