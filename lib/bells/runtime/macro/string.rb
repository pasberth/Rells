require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::String < Bells::Runtime::Macro::Object
  
  def to_s
    receiver.to_s
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
    env[:==] = create_a Macro::Func, self do |_, *a|
      if _.receiver.receiver == a[0].receiver
        _.env[:true]
      else
        _.env[:false]
      end
    end
  end
end
