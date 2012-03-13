require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros
  
  initial_load do |env|
    env[:macro] = create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Macro::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Macro::Node::Symbol }
      _.dynamic_context.create_a Macro::PureMacro do |_, *args|
        args = Hash[*params.flat_map do |a|
          case a.receiver[0]
          when '*'
            ret = [a, args.clone]
            args.clear
            ret
          else
            [a, args.shift || _.dynamic_context.env[:nil]]
          end
        end]
        rest = args
        expand = ->(node) do
          case node
          when Macro::Node::Symbol
            if params.include? node
              args[node]
            else
              node
            end
          when Macro::Node::Macro
            create_a(Macro::Node::Macro, node.receiver.flat_map { |a| expand.(a) })
          else
            node
          end
        end
        _.dynamic_context.eval *stats.map { |node| expand.(node) }
      end
    end
  end
end
