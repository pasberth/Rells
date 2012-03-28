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
    if val = @env[key] then val
    elsif @macro.static_context and val = @macro.static_context.env.find(key) then val
    elsif @macro.dynamic_context and val = @macro.dynamic_context.env.find(key) then val
    else nil
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
    init_env
    self[key]
  end
  
  def []= key, val
    def self.[]= key, val
      raise "ID must be a Symbol" unless key.respond_to? :to_sym
      @env[key.to_sym] = val
      val
    end
    init_env
    self[key] = val
  end
  
  private
    def init_env
      unless @initialized_env
        @macro.init_env self
        @initialized_env = true
      end
    end
end