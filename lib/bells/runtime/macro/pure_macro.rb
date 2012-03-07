require 'bells/runtime/macro'

class Bells::Runtime::Macro::PureMacro < Bells::Runtime::Macro
  
  def initialize &native_function
    if block_given?
      @native_function = native_function
    else
      stats # TODO
    end
  end
  
  def bells_eval *nodes
    @native_function.call @static_context, *nodes
  end
end