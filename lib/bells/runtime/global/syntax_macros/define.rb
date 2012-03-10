require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:define] = bells_create_a Macro::PureMacro do |_, *nodes|
      var = _.bells_env.dynamic_context.bells_create_a Macro::Symbol, nodes.shift.symbol
      val = _.bells_env.dynamic_context.bells_eval nodes.shift
      _.bells_env.dynamic_context.bells_env[var] = val
      val
    end
  end
end