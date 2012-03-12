require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Env

  include Bells::Runtime
  
  def initialize macro
    @env = {}
    @macro = macro
  end
  
  def [] key
    def self.[] key
      raise "ID must be a Symbol" unless key.respond_to? :to_sym

      if val = @env[key.to_sym]
        val.bind( @macro )
      elsif val = @macro.static_context && @macro.static_context.env[key]
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