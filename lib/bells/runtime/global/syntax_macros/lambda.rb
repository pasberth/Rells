require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:"->"] = create_a Macro::PureMacro do |_, *nodes|
      params, stats = nodes.split_in_while { |a| a.is_a? Macro::Node::Symbol }

      f = _.dynamic_context.create_a Macro::Func, _.dynamic_context do |_, *args|
        e = _.create_a Macro::Eval, _
        e.env[:self] = _.static_context
        # e.env[:here] = e
        params.each { |a| e.env[a.receiver] = args.shift }
        e.eval *stats
      end
      f.env[:to_s] = f.create_a(Macro::String, "-> #{params.map { |a| a.env[:to_s].eval.eval }.join ', '}\n  #{stats.join "\n  "}")
      f
    end
  end
end
