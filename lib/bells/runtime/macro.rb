require 'bells/runtime'
require 'bells/runtime/macro_helper'

class Bells::Runtime::Macro

  include Bells::Runtime
  include Bells::Runtime::MacroHelper
  
  attr_accessor :receiver
  attr_accessor :static_context
  attr_accessor :dynamic_context
  
  def initialize *args
    @receiver = self
    @env = {}
  end
  
  def init_env
  end
  
  def [] key
    @env ||= {}
    init_env
    def self.[] key
      if val = ( @env[key] or
                 @static_context && @static_context[key] or
                 @dynamic_context && @dynamic_context[key] )
        val.bind self
      else
        fail
      end
    end
    self[key]
  end
  
  def []= key, val
    @env ||= {}
    @env[key] = val
    val
  end
  
  def bind macro
    clone.tap do |a|
      a.dynamic_context = macro
    end
  end
  
  def create_a macro_class, *args, &block
    macro = macro_class.new *args, &block
    macro.static_context = self
    macro.dynamic_context = self
    macro
  end
  
  def bells_eval *nodes
  end
end

require 'bells/runtime/macro/pure_macro'
require 'bells/runtime/macro/symbol'
require 'bells/runtime/macro/string'
require 'bells/runtime/macro/func'
require 'bells/runtime/macro/eval'