require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::String < Bells::Runtime::Macro::Object
  
  def to_s
    receiver.to_s
  end
  
  def to_str
    receiver.to_str
  end
  
  def inspect
    receiver.inspect
  end
  
  def == other
    receiver == other.receiver
  rescue
    false
  end

  def eql? other
    receiver.eql? other.receiver
  rescue
    false
  end

  def hash
    receiver.hash
  end

  def init_env env
    super
    env[:to_s] = self
  end
end
