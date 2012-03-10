require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::String < String
  
  include Bells::Runtime::Macro::Objectable
  
  def to_rb
    self
  end
  
  def bells_init_env env
    env[:to_s] = self
  end
end
