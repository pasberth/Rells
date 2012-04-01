require 'bells/syntax'
require 'bells/syntax/bellsc'

class Bells::Syntax::Parser
  
  include Bells::Syntax
  include Bells::Syntax::Bellsc

  def self.load_bellsc input
    case c = input.getc
    when BELLSC_PROGRAM_DATA_BEGIN
      load_bellsc_program_data(input)
    end
  end
  
  def self.load_bellsc_program_data input
    stack = [[]]
    while c = input.getc
      case c
      when BELLSC_MACRO_BEGIN
        stack.push []
        next
      when BELLSC_EXP_END
        macro = stack.pop
        stack.last.push Node::Macro.new macro.shift, *macro
        next
      when BELLSC_SYMBOL_BEGIN
        stack.last.push Node::Symbol.new input.gets(BELLSC_EXP_END)[0..-2].intern
      when BELLSC_INTEGER_BEGIN
        stack.last.push Node::Integer.new input.gets(BELLSC_EXP_END)[0..-2].to_i
      when BELLSC_STRING_BEGIN
        stack.last.push Node::String.new input.gets(BELLSC_EXP_END)[0..-2]
      end
    end
    stack[0][0]
  end
  
  def self.dump_bellsc node
    dump_bellsc_program_data node
  end
  
  def self.dump_bellsc_program_data node
    bellsc = "#{BELLSC_PROGRAM_DATA_BEGIN}"
    bellsc << node.dump_bellsc
    bellsc << BELLSC_DATA_END
    bellsc
  end

  def decode_bellsc input
    Parser.load_bellsc(input)
  end
  
  def encode_bellsc node
    Parser.dump_bellsc(node)
  end

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
        #if (rest = input.read) !~ /\A[ \n]*\z/
        #  raise Bells::Syntax::SyntaxError, "Unexpected #{rest[0].inspect} in #{rest.each_line.first.inspect}."
        #end
      end))
    toplevel
  end
end