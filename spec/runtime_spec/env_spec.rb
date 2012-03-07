require 'spec_helper'

describe Bells::Runtime::Env do
  
  %w[puts].each do |a|
    its([Bells::Runtime::Macro::Symbol.new(a)]) { should_not be_nil }
  end
end