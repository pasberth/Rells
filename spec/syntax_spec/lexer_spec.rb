require 'spec_helper'

describe Bells::Syntax::Lexer do
  
  include Bells::Syntax

  example do
    program = StringIO.new "puts"
    lexer = described_class.new program
    lexer.send(:symbol).should == Node::Symbol.new(:puts)
  end

  example do
    program = StringIO.new '"hello world"'
    lexer = described_class.new program
    lexer.send(:string).should == Node::String.new('hello world')
  end

  example do
    program = StringIO.new(<<-CODE)
    puts "hello world"
    CODE
    lexer = described_class.new program
    lexer.token.should == Node::Macro.new(
            Node::Symbol.new(:puts),
            Node::String.new("hello world"))
  end

  example do
    program = StringIO.new(<<-CODE)
    puts "hello world"
        array e f g
    CODE
    lexer = described_class.new program
    lexer.token.should == Node::Macro.new(
            Node::Symbol.new(:puts),
            Node::String.new("hello world"),
            Node::Macro.new(
              Node::Symbol.new(:array),
              Node::Symbol.new(:e),
              Node::Symbol.new(:f),
              Node::Symbol.new(:g)
            ))
  end

  example do
    program = StringIO.new(<<-CODE)
    puts "hello world"
    puts "line 2"
    CODE
    lexer = described_class.new program
    lexer.token.should == Node::Macro.new(
            Node::Symbol.new(:puts),
            Node::String.new("hello world"))
    lexer.token.should == Node::Macro.new(
            Node::Symbol.new(:puts),
            Node::String.new("line 2"))
  end

end