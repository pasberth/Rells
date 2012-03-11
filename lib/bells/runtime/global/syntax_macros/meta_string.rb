require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:META_STRING] = bells_create_a Macro::PureMacro do |_, *nodes|
      str = _.bells_env.dynamic_context.bells_create_a Macro::Symbol, nodes.shift.symbol
      _.bells_dynamic_create_a Macro::String, str.to_s
    end
  end
end
