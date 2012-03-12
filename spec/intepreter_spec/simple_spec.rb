require 'spec_helper'
require 'bells/interpreter'

describe do
  subject { Bells::Runtime::Global.new }
  
  example do
    subject.bells_eval_str(<<-CODE).should == subject.create_a(Bells::Runtime::Macro::String, "a")
      ----
      This should ignore
      ----
      "a"
    CODE
  end

  example do
    ret = subject.bells_eval_str(<<-CODE).should == subject.create_a(Bells::Runtime::Macro::Array, %w[hello bells world].map { |e| subject.create_a(Bells::Runtime::Macro::String, e)})
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

    subject.bells_eval_str('f "a"').should == subject.create_a(Bells::Runtime::Macro::String, "a")
  end

  example do
    subject.bells_eval_str(<<-CODE)
      define f $ -> a $ a
    CODE

    subject.bells_eval_str('f "a"').should == subject.create_a(Bells::Runtime::Macro::String, "a")
  end
end
