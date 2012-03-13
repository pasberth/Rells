require 'spec_helper'

describe Bells::Runtime::Global do
  
  %w[puts eval].each do |a|
    it { subject.env[a.intern].should_not be_nil }
  end
  
  example do
    node = Node::Macro.new(
            Node::Symbol.new(:puts),
            Node::String.new("hello world"),
            Node::Macro.new(
              Node::Symbol.new(:array),
              Node::Symbol.new(:e),
              Node::Symbol.new(:f),
              Node::Symbol.new(:g)
            ))
    subject.syntax_node_to_runtime_node(node).should == Macro::Node.new(
            Macro::Node.new(:puts),
            Macro::Node.new("hello world"),
            Macro::Node.new(
              Macro::Node.new(:array),
              Macro::Node.new(:e),
              Macro::Node.new(:f),
              Macro::Node.new(:g)
            ))
  end
  
  example do
    str = subject.create_a Bells::Runtime::Macro::String, "string"
    str.env[:to_s].eval.should == subject.create_a(Bells::Runtime::Macro::String, "string")
  end
  
  example do
    sym = subject.create_a Bells::Runtime::Macro::Symbol, :symbol
    sym.env[:to_s].eval.should == subject.create_a(Bells::Runtime::Macro::String, "symbol")
  end
  
  example do
    func = subject.create_a Bells::Runtime::Macro::Func, subject do |_, *a|
      _.should == func
      _.receiver.should == subject
      "return value"
    end
    func.eval.should == "return value"
  end
end