require 'bells/runtime/macro'

class Bells::Runtime::Macro::Func < Bells::Runtime::Macro
  
  def initialize *stats, &native_function
    super
    if block_given?
      @func = native_function
    else
      stats # TODO
    end
  end
  
  def bells_eval *args
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then Macro::Symbol.new node.token
      when Bells::Syntax::Node::String then Macro::String.new node.token
      when Bells::Syntax::Node::Macro
        self[e.(node.node)].bells_eval(*node.args)
      end
    end
    
    @func.( self, *args.map { |node| e.(node) } )
  end
end
