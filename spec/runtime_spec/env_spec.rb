require 'spec_helper'

describe Bells::Runtime::Env do
  
  %w[puts eval].each do |a|
    its([Bells::Runtime::Macro::Symbol.new(a.intern)]) { should_not be_nil }
  end
  
  example do
    str = subject.create_a Bells::Runtime::Macro::String, "string"
    str[subject.var :to_s].bells_eval.string.should == "string"
  end
  
  example do
    sym = subject.create_a Bells::Runtime::Macro::Symbol, :symbol
    sym[subject.var :to_s].bells_eval.string.should == "symbol"
  end
  
  example do
    func = subject.create_a Bells::Runtime::Macro::Func, subject do |_, *a|
      _.receiver.should == subject
      "return value"
    end
    func.bells_eval.should == "return value"
  end
end