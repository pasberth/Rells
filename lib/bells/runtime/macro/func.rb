require 'bells/runtime/macro'

class Bells::Runtime::Macro::Func < Bells::Runtime::Macro
  
  def initialize receiver, *stats, &native_function
    super
    @receiver = receiver
    if block_given?
      @func = native_function
    else
      stats # TODO
    end
  end
  
  def bells_eval *args
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then create_a Macro::Symbol, node.symbol
      when Bells::Syntax::Node::String then create_a Macro::String, node.string
      when Bells::Syntax::Node::Macro
        e.(node.node).bells_eval *node.args
      end
    end
    
    @func.( @receiver, *args.map { |node| e.(node) } )
  end
end
