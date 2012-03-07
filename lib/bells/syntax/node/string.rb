require 'bells/syntax/node'

class Bells::Syntax::Node::String
  
  attr_reader :string

  def initialize string
    @string = string
  end
  
  def == other
    string == other.string
  rescue
    false
  end
end
