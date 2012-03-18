require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Env

  include Bells::Runtime
  
  attr_accessor :macro
  protected :macro, :macro=
  
  def initialize macro
    @env = {}
    @macro = macro
  end
  
  def bind macro
    val = clone
    val.macro = macro
    val
  end
  
  def find key
    raise "ID must be a Symbol" unless key.respond_to? :to_sym
    if val = @env[key]
      val
    elsif val = @macro.static_context && @macro.static_context.env.find(key)
      val
    elsif val = @macro.dynamic_context && @macro.dynamic_context.env.find(key)
      val
    else
      nil
    end
  end
  
  def [] key
    def self.[] key
      raise "ID must be a Symbol" unless key.respond_to? :to_sym
      key = key.to_sym
      if val = find(key)
        val.bind( @macro )
      else
        self[:nil]
      end
    end
    @macro.init_env self
    self[key]
  end
  
  def []= key, val
    raise "ID must be a Symbol" unless key.respond_to? :to_sym
    @env[key.to_sym] = val
    val
  end
end