require 'pasparse'

class Bells::Syntax::Lexer < PasParse::Lexer
  
  include Bells::Syntax
  
  state_attr_accessor :indent
  
  def initialize input=$stdin
    super
    @indent = -1
  end
  
  def token
    primary
  end

  private
    def primary
      macro or symbol or string
    end
    
    def symbol
      try do
        s = many1(/[a-zA-Z]/)
        Token::Symbol.new s.join
      end
    end
    
    def string
      try do
        s = between('"', '"') { many(/(?!")./) }
        Token::Symbol.new s.join
      end
    end
    
    def macro
      try do
        if @indent < 0
          @indent = 0
        else
          expect "\n"
        end
        expect ' ' * @indent
        new_indent = many ' '
        @indent += new_indent.length + 1
        a = primary
        as = macro_args
        Token::Macro.new a, *as
      end
    end
    
    def macro_args
      many do
        many ' '
        primary
      end
    end
end

require 'bells/syntax/token'