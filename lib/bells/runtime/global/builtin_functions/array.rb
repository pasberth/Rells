require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:array] = create_a Macro::Func, self do |_, *elems|
      _.dynamic_context.create_a Macro::Array, elems
    end
  end
end
