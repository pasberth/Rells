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
      try do
        comment
        macro or blank_line or integer or symbol or string or hyphenation or raise Unexpected
      end or raise Unexpected
    end
    
    %w[primary symbol string macro macro_args blank_line hyphenation comment one_line_comment multi_line_comment integer].each do |a|
      class_eval(<<-CODE)
        def #{a}
          try { #{a}! }
        end
      CODE
    end
    
    def comment!
      multi_line_comment or one_line_comment or raise Unexpected
    end
    
    def one_line_comment!
      expect! "\n"
      many ' '
      mark = expect(/(?!\s)./)
      3.times { expect(mark) }
      many { expect! mark }.join
      Node::Comment.new many(/./).join
    end
    
    def multi_line_comment!
      if @indent < 0
        @indent = 0
      else
        expect! "\n"
      end
      many ' '
      comment_frame  = ""
      mark = expect(/(?!\s)./)
      comment = ""
      comment_frame << mark
      3.times { comment_frame << expect(mark) }
      comment_frame << many { expect! mark }.join
      many ' '
      expect "\n"
      comment = many do
        unexpect! comment_frame and expect!(/./m)
      end.join
      expect comment_frame
      Node::Comment.new comment
    end
    
    def hyphenation!
      expect "\n"
      many ' '
      expect '--'
      many ' '
      primary!
    end
    
    def integer!
      Node::Integer.new many1(/\d/).join.to_i
    end
    
    def symbol!
      # reserved words
      unexpect '--'
      unexpect '$'
      s = many1(/[\w\+\/\-\>\<\*]/)
      Node::Symbol.new s.join.intern
    end
    
    def string!
      raise Unexpected if touch!('--')
      s = between('"', '"') { many(/(?!")./) }
      Node::String.new s.join
    end
    
    def macro!
      try {
        many {
          try {
            expect "\n"
            many ' '
          }
        }
        expect "$"
        many1 ' '
        a = primary!
        as = macro_args!
        try {
          many {
            try {
              expect "\n"
              many ' '
            }
          }
          comment
          expect '.'
          as2 = macro_args!
          Node::Macro.new Node::Macro.new(a, *as), *as2
        } or (
          Node::Macro.new a, *as
        )
      } or try {
        if @indent < 0
          @indent = 0
        else
          expect "\n"
        end
        origin_indent = @indent
        expect ' ' * @indent
        new_indent = many ' '
        @indent += new_indent.length + 1
        unexpect '--'
        a = primary!
        as = macro_args!
        try {
          many {
            try {
              expect "\n"
              many ' '
            }
          }
          comment
          expect '.'
          as2 = macro_args!
          @indent = origin_indent
          Node::Macro.new Node::Macro.new(a, *as), *as2
        } or (
          @indent = origin_indent
          Node::Macro.new a, *as
        )
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
