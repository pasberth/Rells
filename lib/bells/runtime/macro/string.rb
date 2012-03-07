require 'bells/runtime/macro'

class Bells::Runtime::Macro::String < Bells::Runtime::Macro
  
  attr_reader :string

  def initialize string
    @string = string
  end
  
  def eql? other
    @string.eql? other.string
  rescue
    false
  end
  
  def hash
    @string.hash
  end
  
  def == other
    string == other.string
  rescue
    false
  end
end
