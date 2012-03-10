require 'spec_helper'
require 'bells/interpreter'

describe do
  subject { Bells::Runtime::Env.new }
  
  example do
    subject.bells_eval_str(<<-CODE).should == Bells::Runtime::Macro::String.new("a")
      ----
      This should ignore
      ----
      "a"
    CODE
  end

  example do
    ret = subject.bells_eval_str(<<-CODE).should == Bells::Runtime::Macro::Array.new(*(%w[hello bells world].map { |s| Bells::Runtime::Macro::String.new(s) }))
      define f
        -> a
          -> b
            -> c
              array a b c
      define g $ f "hello"
      define h $ g "bells"
      h "world"
    CODE
  end

  example do
    subject.bells_eval_str(<<-CODE)
      define f
        -> a
          a
    CODE

    subject.bells_eval_str('f "a"').should == Bells::Runtime::Macro::String.new("a")
  end

  example do
    subject.bells_eval_str(<<-CODE)
      define f $ -> a $ a
    CODE

    subject.bells_eval_str('f "a"').should == Bells::Runtime::Macro::String.new("a")
  end
end
