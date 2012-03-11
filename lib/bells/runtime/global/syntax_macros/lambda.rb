require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:"->"] = bells_create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      
      f = _.bells_env.dynamic_context.bells_create_a Macro::Func, _.bells_env.dynamic_context do |_, f, *args|
        e = _.bells_create_a Macro::Eval
        params.each { |a| e.bells_env[_.bells_value a.symbol] = args.shift }
        e.bells_eval *stats
      end
      f.bells_env[:to_s] = f.bells_value("-> #{params.join ', '}\n  #{stats.join "\n  "}")
      f
    end
  end
end
