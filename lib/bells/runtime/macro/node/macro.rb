require 'bells/runtime/macro'
require 'bells/runtime/macro/node'
require 'give4each'

class Bells::Runtime::Macro::Node::Macro < Bells::Runtime::Macro::Node
  
  def to_s
    "(#{receiver.join ' '})"
  end

  def eval *nodes
    val, args = receiver[0].eval, receiver[1..-1]
    val.eval *args
  end
  
  def bind macro
    val = super
    val.receiver = receiver.map &:bind.with(val.dynamic_context)
    val
  end

  def init_env env
    super
    env[:to_s] = create_a Macro::String, "(#{receiver})"
    env[:nil?] = env[:false]
  end
end
