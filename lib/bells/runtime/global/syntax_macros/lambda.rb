require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:"->"] = create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }

      f = _.dynamic_context.create_a Macro::Func, _.dynamic_context do |_, *args|
        e = _.create_a Macro::Eval
        params.each { |a| e.env[a.symbol] = args.shift }
        e.eval *stats
      end
      f.env[:to_s] = f.create_a(Macro::String, "-> #{params.join ', '}\n  #{stats.join "\n  "}")
      f
    end
  end
end
