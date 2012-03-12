require 'spec_helper'

describe  Bells::Syntax::Parser do

  example do
    bellsc = "\x82\xa4hello world\xa0\x80"
    subject.decode_bellsc(StringIO.new(bellsc)).should == Node::String.new("hello world")
  end

  example do
    bellsc = "\x82\xa2puts\xa0\x80"
    subject.decode_bellsc(StringIO.new(bellsc)).should == Node::Symbol.new(:puts)
  end

  example do
    bellsc = "\x82\xa3100\xa0\x80"
    subject.decode_bellsc(StringIO.new(bellsc)).should == Node::Integer.new(100)
  end

  example do
    bellsc = "\x82\xa1\xa2puts\xa0\xa4hello world\xa0\xa0\x80"
    subject.decode_bellsc(StringIO.new(bellsc)).should == Node::Macro.new(
            Node::Symbol.new(:puts),
            Node::String.new("hello world"))
  end

  example do
    bellsc = "\x82\xa1\xa2eval\xa0\xa1\xa2puts\xa0\xa4hello world\xa0\xa0\xa0\x80"
    subject.decode_bellsc(StringIO.new(bellsc)).should == Node::Macro.new(
            Node::Symbol.new(:eval),
            Node::Macro.new(
              Node::Symbol.new(:puts),
              Node::String.new("hello world")))
  end
  
  example do
    bellsc = "\x82\xa4hello world\xa0\x80"
    subject.encode_bellsc(Node::String.new("hello world")).should == bellsc
  end

  example do
    bellsc = "\x82\xa2puts\xa0\x80"
    subject.encode_bellsc(Node::Symbol.new(:puts)).should == bellsc
  end

  example do
    bellsc = "\x82\xa3100\xa0\x80"
    subject.encode_bellsc(Node::Integer.new(100)).should == bellsc
  end

  example do
    bellsc = "\x82\xa1\xa2puts\xa0\xa4hello world\xa0\xa0\x80"
    subject.encode_bellsc(Node::Macro.new(
            Node::Symbol.new(:puts),
            Node::String.new("hello world"))).should == bellsc
  end

  example do
    bellsc = "\x82\xa1\xa2eval\xa0\xa1\xa2puts\xa0\xa4hello world\xa0\xa0\xa0\x80"
    subject.encode_bellsc(Node::Macro.new(
            Node::Symbol.new(:eval),
            Node::Macro.new(
              Node::Symbol.new(:puts),
              Node::String.new("hello world")))).should == bellsc
  end
end