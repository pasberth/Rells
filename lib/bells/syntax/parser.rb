require 'bells/syntax'
class Bells::Syntax::Parser
  
  include Bells::Syntax
  
  def parse input
    if input.respond_to? :to_io
      input = input.to_io
      lexer = Lexer.new input
    elsif input.respond_to? :to_str
      input = StringIO.new input.to_str
      lexer = Lexer.new input
    else
      lexer = Lexer.new input
    end
    
    toplevel = Node::Macro.new(
      Node::Symbol.new(:eval), 
      *([].tap do |a|
        while t = lexer.token
          a << t
        end
        if (rest = input.read) !~ /\A[ \n]*\z/
          raise Bells::Syntax::SyntaxError, "Unexpected #{rest[0].inspect} in #{rest.each_line.first.inspect}."
        end
      end))
    toplevel
  end
end