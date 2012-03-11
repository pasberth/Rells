require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::BellsEnv

  include Bells::Runtime

  attr_accessor :itself
  attr_accessor :receiver
  attr_accessor :static_context
  attr_accessor :dynamic_context

  def initialize receiver, itself=receiver
    @env = {}
    @receiver = receiver
    @itself = itself
  end
  
  def [] key
    def self.[] key
      key = create_a(Macro::Symbol, key) if key.is_a? ::Symbol

      if val = ( @env[key] or
                 @static_context && @static_context.bells_env[key] )
        val.bells_bind receiver
      else
        self[:nil]
      end
    end
    itself.bells_init_env self
    self[key]
  end
  
  def []= key, val
    key = create_a(Macro::Symbol, key) if key.is_a? ::Symbol
    @env[key] = val
    val
  end
  
  def bind macro
    a = itself.clone
    a.bells_env = itself.bells_env.clone
    a.bells_env.itself = a
    a.bells_env.dynamic_context = macro
    a
  end
  
  def create_a macro_class, *args, &block
    macro = macro_class.new *args, &block
    macro.bells_env.static_context = receiver
    macro.bells_env.dynamic_context = receiver
    macro
  end
  
  def static_create_a macro_class, *args, &block
    (static_context || receiver).bells_env.create_a macro_class, *args, &block
  end
  
  def dynamic_create_a macro_class, *args, &block
    (dynamic_context || receiver).bells_env.create_a macro_class, *args, &block
  end
  
  def static_eval *args, &block
    (static_context || receiver).bells_env.eval *args, &block
  end
  
  def dynamic_eval *args, &block
    (dynamic_context || receiver).bells_eval *args, &block
  end
  
  def condition
    true
  end

  def require path
    self[:require].bells_eval(Bells::Syntax::Node::String.new path)
  end
  
  def eval *nodes
    receiver
  end
end