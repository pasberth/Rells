require 'bells/syntax'
require 'pasparsec'

module Bells::Syntax::ParserCombinators

class Base < PasParsec::Parser::Base
  
  include Bells::Syntax
  add_state_attr :indent
end

class StringParser < Base
  
  def parse
    Node::String.new( between('"', '"', many(one_of([%q{\"}, none_of('"')]))).call.join )
  end
end
  
Base.add_parser :bestr, StringParser

class SkipSpaces < Base
  
  def parse
    try(comment).call || try(skip_line).call || try(skip_space).call and skip_spaces.call
  end
end

Base.add_parser :skip_spaces, SkipSpaces

class RequireNewLine < Base
  
  def parse
    indent ? string("\n").call : (self.indent = 0; '')
  end
end

Base.add_parser :require_new_line, RequireNewLine

class SkipSpace < Base

  def parse
    indent ? many1(' ').call.join : parsing_fail
  end
end

Base.add_parser :skip_space, SkipSpace

class SkipLine < Base
  
  def parse
    result = require_new_line.call + many(' ').call.join
    try do
      if try(one_of ['$ ', '. ', '-- ', "\n"]).call
        refresh_states
        true
      else
        false
      end
    end.call ?
        result : comment.call
  end
end

Base.add_parser :skip_line, SkipLine


class CommentParser < Base
  
  def parse
    try(multi_line_comment).call or try(one_line_comment).call or parsing_fail
  end
end

Base.add_parser :comment, CommentParser

class OneLineComment < Base

  def parse
    #many(' ').call
    mark = none_of(" \n").call
    string(mark * 3).call
    many(mark).call
    Node::Comment.new (many(' ').call + many(none_of(" \n")).call + many(none_of("\n")).call).join
  end
end

Base.add_parser :one_line_comment, OneLineComment

class MultiLineComment < Base

  def parse
    #if indent then string("\n") else self.indent = 0 end
    #many(' ').call
    mark = none_of(" \n").call
    string(mark * 3).call
    comment_frame = mark * 4
    comment_frame << many(mark).call.join
    many(' ').call
    require_new_line.call
    comment = many(none_of([comment_frame])).call.join
    string(comment_frame).call
    Node::Comment.new comment
  end
end

Base.add_parser :multi_line_comment, MultiLineComment

class SymbolParser < Base
  
  def parse
    Node::Symbol.new( (none_of([' ', "\n", '"', '-- ', '$ ', '. ']).call + many(none_of(" \n")).call.join).intern )
  end
end

Base.add_parser :besym, SymbolParser

class IntegerParser < Base
  
  def parse
    Node::Integer.new( many1(one_of("0123456789")).call.join.to_i )
  end
end

Base.add_parser :beint, IntegerParser

class MacroParser < Base
  
  def parse
    dot_macro.call
  end
end

Base.add_parser :bemacro, MacroParser

class MacroBodyParser < Base
  
  def parse
    a = bepri.call
    as = many(bepri).call
    Node::Macro.new(a, *as)
  end
end

Base.add_parser :macro_body, MacroBodyParser

class IndentMacroParser < Base

  def parse
    require_new_line.call
    string(' ' * indent).call
    org_indent = indent
    new_indent = many(' ').call.length
    self.indent = org_indent + new_indent + 1
    result = macro_body.call
    self.indent = org_indent
    result
  end
end

Base.add_parser :indent_macro, IndentMacroParser

class DollarMacroParser < Base
  
  def parse
    string('$ ').call
    skip_spaces.call
    macro_body.call
  end
end

Base.add_parser :dollar_macro, DollarMacroParser

class DotMacroParser < Base
  
  def parse
    a = try(indent_macro).call || try(dollar_macro).call || parsing_fail
    try do
      skip_spaces.call
      string('. ').call
      as = many(bepri).call
      Node::Macro.new(a, *as)
    end.call or a
  end
end

Base.add_parser :dot_macro, DotMacroParser

class HyphenationParser < Base
  def parse
    string('-- ').call
    skip_spaces.call
    bepri.call
  end
end

Base.add_parser :hyphenation, HyphenationParser

class PrimaryParser < Base
  def parse
    skip_spaces.call
    try(hyphenation).call or
    try(bemacro).call or
    try(beint).call or
    try(besym).call or
    try(bestr).call or
    parsing_fail
  end
end

Base.add_parser :bepri, PrimaryParser
end

class Bells::Syntax::Lexer < Bells::Syntax::ParserCombinators::Base
  
  def initialize input
    super()
    self.input = input
    self.pos = input.pos
  end
  
  def token
    try(bepri).call
  end
  
  def parse
  end
end