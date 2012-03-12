require 'bells/runtime/macro'

class Bells::Runtime::Macro::Func < Bells::Runtime::Macro
  
  def initialize static_context, receiver=self, &native_function
    super
    @func = native_function
  end
  
  def eval *args
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then dynamic_context.create_a(Macro::Symbol, node.symbol).eval
      when Bells::Syntax::Node::String then dynamic_context.create_a(Macro::String, node.string).eval
      when Bells::Syntax::Node::Integer then dynamic_context.create_a(Macro::Integer, node.integer).eval
      when Bells::Syntax::Node::Macro
        e.(node.node).eval *node.args
      end
    end
    
    @func.( self,
            *args.map { |node| e.(node) } )
  end
end
