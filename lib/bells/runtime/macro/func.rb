require 'bells/runtime/macro'

class Bells::Runtime::Macro::Func
  include Bells::Runtime::Macro
  
  def initialize receiver, &native_function
    super
    @receiver = receiver
    @func = native_function
  end
  
  def bells_env
    @bells_env ||= ::Bells::Runtime::BellsEnv.new @receiver, self 
  end
  
  def bells_eval *args
    e = ->(node) do
      case node
      when Bells::Syntax::Node::Symbol then bells_dynamic_create_a(Macro::Symbol, node.symbol).bells_eval
      when Bells::Syntax::Node::String then bells_dynamic_create_a(Macro::String, node.string).bells_eval
      when Bells::Syntax::Node::Integer then bells_dynamic_create_a(Macro::Integer, node.integer).bells_eval
      when Bells::Syntax::Node::Macro
        e.(node.node).bells_eval *node.args
      end
    end
    
    @func.( bells_env.receiver, self,
            *args.map { |node| e.(node) } )
  end
end
