require 'bells/syntax'
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

    def primary!
      macro or blank_line or symbol or string or raise Unexpected
    end
    
    %w[primary symbol string macro macro_args blank_line].each do |a|
      class_eval(<<-CODE)
        def #{a}
          try { #{a}! }
        end
      CODE
    end
    
    def symbol!
      s = many1(/[a-zA-Z\-\>\<]/)
      Node::Symbol.new s.join.intern
    end
    
    def string!
      s = between('"', '"') { many(/(?!")./) }
      Node::String.new s.join
    end
    
    def macro!
      try {
        if @indent < 0
          @indent = 0
        else
          expect "\n"
        end
        origin_indent = @indent
        expect ' ' * @indent
        new_indent = many ' '
        @indent += new_indent.length + 1
        a = primary!
        as = macro_args!
        @indent = origin_indent
        Node::Macro.new a, *as
      } or try {
        expect "$"
        many1 ' '
        a = primary!
        as = macro_args!
        Node::Macro.new a, *as
      } or raise Unexpected
     end
    
    def macro_args!
      many do
        many ' '
        primary
      end
    end
    
    def blank_line!
      macro or try {
        expect "\n"
        many ' '
        blank_line!
      } or raise Unexpected
    end
end
