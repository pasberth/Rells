require 'bells/syntax/node'

class Bells::Syntax::Node::Symbol
  
  attr_reader :token

  def initialize token
    @token = token
  end
  
  def == other
    token == other.token
  rescue
    false
  end
end