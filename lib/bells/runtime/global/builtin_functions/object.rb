require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:object] = env.create_a Macro::PureMacro do |_, *nodes|
      _.bells_env.dynamic_context.bells_create_a Macro::Object
    end
  end
end
