require 'bells/runtime'

class Bells::Runtime::Macro

  include Bells::Runtime
  
  attr_accessor :context
  
  def initialize *args
    @env = {}
  end
  
  def [] macro
    @env[macro] or @context[macro]
  end
  
  def create_a macro_class, *args, &block
    macro = macro_class.new *args, &block
    macro.context = self
    macro
  end
  
  def bells_eval *nodes
  end
end

require 'bells/runtime/macro/symbol'
require 'bells/runtime/macro/string'
require 'bells/runtime/macro/func'
require 'bells/runtime/macro/eval'