require 'bells/runtime/macro'

class Bells::Runtime::Macro::Symbol < Bells::Runtime::Macro
  
  def eval *nodes
    static_context.env[receiver]
  end

  def init_env env
    super
    env[:to_s] = create_a Macro::String, receiver.to_s
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
end
