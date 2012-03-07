require 'bells/runtime'
require 'bells/runtime/macro_helper'

class Bells::Runtime::Macro

  include Bells::Runtime
  include Bells::Runtime::MacroHelper
  
  attr_accessor :context
  
  def initialize *args
    @env = {}
  end
  
  def init_env
  end
  
  def [] macro
    init_env
    def self.[] macro
      @env[macro] or @context && @context[macro]
    end
    self[macro]
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