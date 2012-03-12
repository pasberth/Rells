require 'bells/runtime/macro'

class Bells::Runtime::Macro::PureMacro < Bells::Runtime::Macro
  
  def initialize static_context, receiver=self, &native_function
    super
    @native_function = native_function
  end
  
  def eval *nodes
    @native_function.call self, *nodes
  end
end