require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:object] = create_a Macro::PureMacro do |_, *nodes|
      _.dynamic_context.create_a Macro::Object
    end
  end
end
