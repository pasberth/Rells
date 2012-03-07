require 'bells/syntax/token'

class Bells::Syntax::Token::Macro
  
  attr_reader :token, :args

  def initialize token, *args
    @token = token
    @args = args
  end
  
  def == other
    token == other.token
    args == other.args
  rescue
    false
  end
end