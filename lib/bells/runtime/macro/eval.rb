require 'bells/runtime/macro'

class Bells::Runtime::Macro::Eval < Bells::Runtime::Macro
  
  def eval *nodes
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then create_a(Macro::Symbol, node.symbol).eval
      when Bells::Syntax::Node::String then create_a(Macro::String, node.string).eval
      when Bells::Syntax::Node::Integer then create_a(Macro::Integer, node.integer).eval
      when Bells::Syntax::Node::Macro
        e.(node.node).eval *node.args
      end
    end
    
    nodes.inject(env[:nil]) { |result, node| e.(node) }
  end
end
