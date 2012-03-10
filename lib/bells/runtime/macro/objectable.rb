require 'bells/runtime/macro'

module Bells::Runtime::Macro::Objectable
  
  include Bells::Runtime::Macro
  
  def bells_init_env env
    env[:to_s] = bells_value("<a object 0x%x>"  % __id__)
  end

  def bells_eval *nodes
    return self if nodes.empty?

    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then bells_create_a(Macro::Symbol, node.symbol).bells_eval
      when Bells::Syntax::Node::String then bells_create_a(Macro::String, node.string).bells_eval
      when Bells::Syntax::Node::Integer then bells_create_a(Macro::Integer, node.integer).bells_eval
      end
    end
    
    f = ->(node) do
      case node
      when Bells::Syntax::Node::Macro
        ret = e.(node.node).bells_eval *node.args
        if nodes.empty?
          ret
        else
          ret.bells_eval *nodes
        end
      else
        e.(node).bells_eval *nodes
      end
    end
    
    f.(nodes.shift)
  end
end
