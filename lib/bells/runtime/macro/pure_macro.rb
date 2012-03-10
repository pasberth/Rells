require 'bells/runtime/macro'

class Bells::Runtime::Macro::PureMacro
  include  Bells::Runtime::Macro
  
  def initialize &native_function
    @native_function = native_function
  end
  
  def bells_eval *nodes
    @native_function.call self, *nodes
  end
end