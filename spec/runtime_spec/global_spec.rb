require 'spec_helper'

describe Bells::Runtime::Global do
  
  %w[puts eval].each do |a|
    it { subject.bells_env[a.intern].should_not be_nil }
  end
  
  example do
    str = subject.bells_create_a Bells::Runtime::Macro::String, "string"
    str.bells_env[:to_s].bells_eval.should == subject.bells_create_a(Bells::Runtime::Macro::String, "string")
  end
  
  example do
    sym = subject.bells_create_a Bells::Runtime::Macro::Symbol, :symbol
    sym.bells_env[:to_s].bells_eval.should == subject.bells_create_a(Bells::Runtime::Macro::String, "symbol")
  end
  
  example do
    func = subject.bells_create_a Bells::Runtime::Macro::Func, subject do |_, *a|
      _.bells_env.receiver.should == subject
      "return value"
    end
    func.bells_eval.should == "return value"
  end
end