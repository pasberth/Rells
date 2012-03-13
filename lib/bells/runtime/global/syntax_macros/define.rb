require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:define] = create_a Macro::PureMacro do |_, *nodes|
      var = nodes.shift.receiver
      val = _.dynamic_context.eval nodes.shift
      _.dynamic_context.env[var] = val
      val
    end
  end
end