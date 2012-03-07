require 'bells/syntax/token'

class Bells::Syntax::Token::Symbol
  
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