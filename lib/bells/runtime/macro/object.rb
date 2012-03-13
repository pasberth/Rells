require 'bells/runtime/macro'

class Bells::Runtime::Macro::Object < Bells::Runtime::Macro
  
  def init_env env
    super
    env[:self] = self
    env[:to_s] = create_a(Macro::String, "<a object 0x%x>"  % receiver.__id__)
  end

  def eval *nodes
    return self if nodes.empty?
    f = ->(node) do
      case node
      when Macro::Node::Macro
        ret = node.bind(self).eval
        if nodes.empty?
          ret
        else
          ret.eval *nodes
        end
      else
        fn = node.bind(self).eval
        fn.eval *nodes
      end
    end
    
    f.(nodes.shift)
  end
end
