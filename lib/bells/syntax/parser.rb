require 'bells/syntax'
class Bells::Syntax::Parser
  
  include Bells::Syntax
  
  def parse input
    if input.respond_to? :to_io
      lexer = Lexer.new input.to_io
    elsif input.respond_to? :to_str
      lexer = Lexer.new StringIO.new input.to_str
    end
    
    toplevel = Node::Macro.new(
      Node::Symbol.new(:eval), 
      *([].tap do |a|
        while t = lexer.token
          a << t
        end
      end))
    toplevel
  end
end