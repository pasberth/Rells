require 'spec_helper'

describe Bells::Runtime::Global do
  
  %w[puts eval].each do |a|
    it { subject.env[a.intern].should_not be_nil }
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