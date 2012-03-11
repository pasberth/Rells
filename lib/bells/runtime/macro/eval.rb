require 'bells/runtime/macro'

class Bells::Runtime::Macro::Eval
  include Bells::Runtime::Macro
  
  def bells_eval *nodes
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then bells_create_a(Macro::Symbol, node.symbol).bells_eval
      when Bells::Syntax::Node::String then bells_create_a(Macro::String, node.string).bells_eval
      when Bells::Syntax::Node::Integer then bells_create_a(Macro::Integer, node.integer).bells_eval
      when Bells::Syntax::Node::Macro
        e.(node.node).bells_eval *node.args
      end
    end
    
    nodes.inject(bells_env[:nil]) { |result, node| e.(node) }
  end
end
