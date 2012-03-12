require 'bells/runtime'

class Bells::Runtime::Macro
  
  include Bells::Runtime

  StaticProperties = Struct.new :static_context, :receiver, :env
  DynamicProperties = Struct.new :dynamic_context
  
  attr_accessor :static_properties, :dynamic_properties
  protected :static_properties=, :dynamic_properties=

  def initialize static_context, receiver=self
    @static_properties = StaticProperties.new static_context, receiver, Env.new(self)
    @dynamic_properties = DynamicProperties.new static_context
  end

  [:receiver, :static_context, :env].each do |prop|
    class_eval(<<-CODE)
     def #{prop}
       @static_properties.#{prop}
     end
     
     def #{prop}= value
       @static_properties.#{prop} = value
     end
     
     protected :#{prop}=
    CODE
  end
  
  [:dynamic_context].each do |prop|
    class_eval(<<-CODE)
     def #{prop}
       @dynamic_properties.#{prop}
     end
     
     def #{prop}= value
       @dynamic_properties.#{prop} = value
     end
     
     protected :#{prop}=
    CODE
  end
  
  def init_env env
    env[:self] = self
    env[:to_s] = create_a Macro::Func, self do |_, *a|
      _.create_a Macro::String, _.receiver.to_s
    end
  end
  
  def bind macro
    val = clone
    val.dynamic_properties = dynamic_properties.clone
    val.dynamic_context = macro
    val
  end
  
  def create_a macro_class, *args, &block
    macro_class.new self, *args, &block
  end

  def condition
    true
  end
  
  def require path
    env[:require].eval(Bells::Syntax::Node::String.new path)
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