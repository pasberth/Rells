require 'bells/runtime/macro'

module Bells::Runtime::MacroHelper
  
  include Bells::Runtime
  
  def var id
    create_a Macro::Symbol, id.intern
  end
end