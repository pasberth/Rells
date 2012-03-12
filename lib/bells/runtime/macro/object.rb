require 'bells/runtime/macro'

class Bells::Runtime::Macro::Object < Bells::Runtime::Macro
  
  def init_env env
    super
    env[:self] = self
    env[:to_s] = create_a(Macro::String, "<a object 0x%x>"  % receiver.__id__)
  end

  def eval *nodes
    return self if nodes.empty?

    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then create_a(Macro::Symbol, node.symbol).eval
      when Bells::Syntax::Node::String then create_a(Macro::String, node.string).eval
      when Bells::Syntax::Node::Integer then create_a(Macro::Integer, node.integer).eval
      end
    end
    
    f = ->(node) do
      case node
      when Bells::Syntax::Node::Macro
        ret = e.(node.node).eval *node.args
        if nodes.empty?
          ret
        else
          ret.eval *nodes
        end
      else
        e.(node).eval *nodes
      end
    end
    
    f.(nodes.shift)
  end
end
