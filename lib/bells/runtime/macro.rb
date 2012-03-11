require 'bells/runtime'

module Bells::Runtime::Macro
  
  include Bells::Runtime
  
  def to_rb
    self
  end
  
  def bells_init_env env
    #env[:self] = self
  end
  
  def bells_value rb_value
    case rb_value
    when ::Symbol then bells_env.create_a Bells::Runtime::Macro::Symbol, rb_value
    when ::String then bells_env.create_a Bells::Runtime::Macro::String, rb_value
    when ::Array then bells_env.create_a Bells::Runtime::Macro::Array, rb_value.map { |e| bells_value e }
    when ::Integer then bells_env.create_a Bells::Runtime::Macro::Integer, rb_value
    else rb_value
    end
  end

  def bells_env
    @bells_env ||= Bells::Runtime::BellsEnv.new(self)
  end
  
  def bells_env= env
    @bells_env = env
  end
  
  def bells_bind receiver
    bells_env.bind receiver
  end
  
  def bells_create_a *args, &block
    bells_env.create_a *args, &block
  end
  
  def bells_static_create_a *args, &block
    bells_env.static_create_a *args, &block
  end
  
  def bells_dynamic_create_a *args, &block
    bells_env.dynamic_create_a *args, &block
  end
  
  def bells_eval *args, &block
    bells_env.eval *args, &block
  end
  
  def bells_static_eval *args, &block
    bells_env.static_eval *args, &block
  end
  
  def bells_dynamic_eval *args, &block
    bells_env.dynamic_eval *args, &block
  end
  
  def bells_require *args, &block
    bells_env.require *args, &block
  end
  
  def bells_condition
    bells_env.condition
  end
  
  def to_s
    "<%s:%s>" % [bells_env[:to_s].bells_eval.to_rb, self.class]
  end
end

require 'bells/runtime/macro/object'
require 'bells/runtime/macro/pure_macro'
require 'bells/runtime/macro/eval'
require 'bells/runtime/macro/nil'
require 'bells/runtime/macro/true'
require 'bells/runtime/macro/false'
require 'bells/runtime/macro/symbol'
require 'bells/runtime/macro/string'
require 'bells/runtime/macro/integer'
require 'bells/runtime/macro/func'
require 'bells/runtime/macro/array'