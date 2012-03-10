require 'spec_helper'
require 'bells/interpreter'

describe do
  subject { Bells::Runtime::Global.new }
  
  example do
    subject.bells_eval_str(<<-CODE).should == subject.bells_value("a")
      ----
      This should ignore
      ----
      "a"
    CODE
  end

  example do
    ret = subject.bells_eval_str(<<-CODE).should == subject.bells_value(%w[hello bells world])
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

    subject.bells_eval_str('f "a"').should == subject.bells_value("a")
  end

  example do
    subject.bells_eval_str(<<-CODE)
      define f $ -> a $ a
    CODE

    subject.bells_eval_str('f "a"').should == subject.bells_value("a")
  end
end
