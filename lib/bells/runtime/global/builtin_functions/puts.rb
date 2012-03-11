require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:puts] = env.create_a Macro::Func, self do |_, f, *args|
      puts args.map { |a| a.bells_env[:to_s].bells_eval.to_rb }
      _.bells_env[:nil]
    end
  end
end
