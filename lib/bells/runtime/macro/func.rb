require 'bells/runtime/macro'

class Bells::Runtime::Macro::Func < Bells::Runtime::Macro
  
  def initialize static_context, receiver=self, &native_function
    super
    @func = native_function
  end
  
  def eval *args
    @func.( self,
            *args.map { |node| node.bind(dynamic_context).eval } )
  end
end
