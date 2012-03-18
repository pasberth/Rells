require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros
  
  initial_load do |env|
    env[:macro] = create_a Macro::PureMacro do |_, *nodes|
      params, stats = nodes.split_in_while { |a| !a.is_a? Macro::Node::Macro }
      _.dynamic_context.create_a Macro::PureMacro do |_, *args|
        args = Hash[*params.flat_map do |a|
          case a.receiver[0]
          when '*'
            [a, args.take_while! { |a| !a.is_a? Macro::Node::Macro }]
          when '&'
            args.take_while! { |a| !a.is_a? Macro::Node::Macro }
            ret = [a, args.clone]
            args.clear
            ret
          else
            if args.first and !args.first.is_a? Macro::Node::Macro
              [a, args.shift]
            else
              [a,  _.dynamic_context.env[:nil]]
            end
          end
        end]
        rest = args
        expand = ->(node) do
          case node
          when Macro::Node::Symbol
            if params.include? node
              if args[node]
                args[node]
              else
                create_a(Macro::Node::Symbol, :nil)
              end
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
