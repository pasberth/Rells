require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:META_STRING] = create_a Macro::PureMacro do |_, *nodes|
      _.dynamic_context.create_a Macro::String, nodes.shift.symbol.to_s
    end
  end
end
