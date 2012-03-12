require 'bells/syntax/node'

class Bells::Syntax::Node::Integer < Bells::Syntax::Node
  
  attr_reader :integer

  def initialize integer
    @integer = integer
  end
  
  def dump_bellsc
    "#{BELLSC_INTEGER_BEGIN}#{integer}#{BELLSC_EXP_END}"
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
