require 'spec_helper'

include Bells::Syntax

describe Bells::Syntax::Lexer do

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
  
  example do
    program = StringIO.new(<<-CODE)
    define f $ -> a $ a
    CODE
    lexer = described_class.new program
    lexer.token.should == Node::Macro.new(
            Node::Symbol.new(:define),
            Node::Symbol.new(:f),
            Node::Macro.new(
              Node::Symbol.new(:"->"),
              Node::Symbol.new(:a),
              Node::Macro.new(
                  Node::Symbol.new(:a))))
  end
  
  example do
    program = StringIO.new(<<-CODE)

    CODE
    lexer = described_class.new program
    lexer.token.should be_nil
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