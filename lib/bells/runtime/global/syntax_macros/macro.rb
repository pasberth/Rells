require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:macro] = env.create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      _.bells_dynamic_create_a Macro::PureMacro do |_, *args|
        args = Hash[*params.flat_map do |a|
          case a.symbol[0]
          when '*'
            ret = [a, args.clone]
            args.clear
            ret
          else
            [a, args.shift || _.bells_env.dynamic_context[:nil]]
          end
        end]
        rest = args
        expand = ->(node) do
          case node
          when Bells::Syntax::Node::Symbol
            if params.include? node
              args[node]
            else
              node
            end
          when Bells::Syntax::Node::Macro
            Bells::Syntax::Node::Macro.new expand.(node.node), *node.args.flat_map { |a| expand.(a) }
          else
            node
          end
        end
        _.bells_dynamic_eval *stats.map { |node| expand.(node) }
      end
    end
  end
end
