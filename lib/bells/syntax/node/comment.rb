require 'bells/syntax/node'

class Bells::Syntax::Node::Comment < Bells::Syntax::Node
  
  attr_reader :comment

  def initialize comment
    @comment = comment
  end
  
  def == other
    comment == other.comment
  rescue
    false
  end
  
  def to_s
    "\n--------\n#{comment}\n--------\n"
  end
end
