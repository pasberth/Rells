require 'bells/runtime/macro'

class Bells::Runtime::Macro::String < Bells::Runtime::Macro
  
  attr_reader :string

  def initialize string
    super
    @string = string
  end
  
  def init_env
    @env[var :to_s] = create_a Macro::Func, self do |_, *a| _.receiver end
  end

  def bells_eval *nodes
    self
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
