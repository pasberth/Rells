require 'bells/runtime/macro'

class Bells::Runtime::Macro::Object < Bells::Runtime::Macro
  
  def init_env
    @env[var :to_s] = create_a Macro::String, "<a object 0x%x>"  % __id__
  end

  def bells_eval *nodes
    return self if nodes.empty?

    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then create_a(Macro::Symbol, node.symbol).bells_eval
      when Bells::Syntax::Node::String then create_a(Macro::String, node.string).bells_eval
      when Bells::Syntax::Node::Integer then create_a(Macro::Integer, node.integer).bells_eval
      end
    end

    f = ->(node) do
      case node
      when Bells::Syntax::Node::Macro
        ret = e.(node.node).bells_eval *node.args
        if nodes.empty?
          ret
        else
          f.(nodes.shift)
        end
      else
        e.(node).bells_eval *nodes
      end
    end
    
    f.(nodes.shift)
  end
end