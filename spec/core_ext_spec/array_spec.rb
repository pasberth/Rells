require 'spec_helper'

describe Array do
  subject { [1, 2, 3, 4, 5] }
  
  example do
    result = subject.take_while! { |i| i < 3 }
    result.should == [1, 2]
    subject.should == [3, 4, 5]
  end
  
  example do
    result = subject.drop_while! { |i| i < 3 }
    result.should == [3, 4, 5]
    subject.should == [1, 2]
  end
  
  example do
    subject.take_while!.should be_is_a Enumerator
  end

  example do
    subject.drop_while!.should be_is_a Enumerator
  end
  
  example do
    take, drop = *subject.split_in_while { |i| i < 3 }
    take.should == [1, 2]
    drop.should == [3, 4, 5]
    subject.should == [1, 2, 3, 4, 5]
  end
end
