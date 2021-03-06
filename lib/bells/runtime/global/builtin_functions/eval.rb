require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:eval] = create_a Macro::Func, self do |_, *args|
      args.last
    end
  end
end
