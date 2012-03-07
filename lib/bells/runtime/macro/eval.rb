require 'bells/runtime/macro'

class Bells::Runtime::Macro::Eval < Bells::Runtime::Macro
  
  def bells_eval *nodes
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then create_a Macro::Symbol, node.symbol
      when Bells::Syntax::Node::String then create_a Macro::String, node.string
      when Bells::Syntax::Node::Macro
        e.(node.node).bells_eval *node.args
      end
    end
    
    nodes.inject(nil) { |result, node| e.(node) }
  end
end
