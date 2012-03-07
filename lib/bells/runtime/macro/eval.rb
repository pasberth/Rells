require 'bells/runtime/macro'

class Bells::Runtime::Macro::Eval < Bells::Runtime::Macro
  
  def bells_eval *nodes
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then Macro::Symbol.new node.token
      when Bells::Syntax::Node::String then Macro::String.new node.token
      when Bells::Syntax::Node::Macro
        self[e.(node.node)].bells_eval(*node.args)
      end
    end
    
    nodes.inject(nil) { |result, node| e.(node) }
  end
end
