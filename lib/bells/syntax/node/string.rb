require 'bells/syntax/node'

class Bells::Syntax::Node::String < Bells::Syntax::Node
  
  attr_reader :string

  def initialize string
    @string = string
  end
  
  def dump_bellsc
    "#{BELLSC_STRING_BEGIN}#{string}#{BELLSC_EXP_END}"
  end

  def == other
    string == other.string
  rescue
    false
  end
  
  def to_s
    string.inspect
  end
end
