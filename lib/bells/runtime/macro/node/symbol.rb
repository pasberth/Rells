require 'bells/runtime/macro'
require 'bells/runtime/macro/node'

class Bells::Runtime::Macro::Node::Symbol < Bells::Runtime::Macro::Symbol
  
  def to_s
    receiver.to_s
  end
end
