require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:puts] = create_a Macro::Func, self do |_, *args|
      puts args.map { |a| a.env[:to_s].eval.eval.to_s }
      _.env[:nil]
    end
  end
end
