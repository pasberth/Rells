require 'spec_helper'

describe Bells::Syntax::Lexer do
  
  include Bells::Syntax

  example do
    program = StringIO.new "puts"
    lexer = described_class.new program
    lexer.send(:symbol).should == Token::Symbol.new("puts")
  end

  example do
    program = StringIO.new '"hello world"'
    lexer = described_class.new program
    lexer.send(:string).should == Token::String.new('hello world')
  end

  example do
    program = StringIO.new(<<-CODE)
    puts "hello world"
    CODE
    lexer = described_class.new program
    lexer.token.should == Token::Macro.new(
            Token::Symbol.new("puts"),
            Token::String.new("hello world"))
  end

  example do
    program = StringIO.new(<<-CODE)
    puts "hello world"
        array e f g
    CODE
    lexer = described_class.new program
    lexer.token.should == Token::Macro.new(
            Token::Symbol.new("puts"),
            Token::String.new("hello world"),
            Token::Macro.new(
              Token::Symbol.new("array"),
              Token::Symbol.new("e"),
              Token::Symbol.new("f"),
              Token::Symbol.new("g")
            ))
  end
end