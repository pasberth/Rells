require 'bells/runtime/macro'

class Bells::Runtime::Macro::Node < Bells::Runtime::Macro
  
  def eval *nodes
    self
  end
  
  def init_env env
    super
    env[:to_s] = create_a Macro::String, "(node)"
  end
end

require 'bells/runtime/macro/node/macro'
require 'bells/runtime/macro/node/symbol'
require 'bells/runtime/macro/node/integer'
require 'bells/runtime/macro/node/string'