require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Env < Bells::Runtime::Macro::Eval
  
  def init_env
    @env[var :global] = self
    
    @env[var :nil] = create_a Macro
    @env[var :nil].instance_eval do
      self[var :to_s] = create_a Macro::String, "(nil)"
    end

    @env[var :to_s] = create_a Macro::Func, self do |_, *args|
      _.receiver.create_a Bells::Runtime::Macro::String, "(global)"
    end

    @env[var :eval] = create_a Macro::Func, self do |_, *args|
      args.last
    end

    @env[var :puts] = create_a Macro::Func, self do |_, *args|
      puts args.map { |a| a[var :to_s].bells_eval.string }
      _.receiver[_.receiver.var :nil]
    end
    
    @env[var :macro] = create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      _.dynamic_context.create_a Macro::PureMacro do |_, *args|
        args = Hash[*params.flat_map { |a| [a, args.shift || _.dynamic_context[var :nil]] }]
        expand = ->(node) do
          case node
          when Bells::Syntax::Node::Symbol
            if params.include? node
              args[node]
            else
              node
            end
          when Bells::Syntax::Node::Macro
            Bells::Syntax::Node::Macro.new expand.(node.node), *node.args.map { |a| expand.(a) }
          else
            node
          end
        end
        _.dynamic_context.bells_eval *stats.map { |node| expand.(node) }
      end
    end
    
    @env[var :define] = create_a Macro::PureMacro do |_, *nodes|
      var = _.dynamic_context.create_a Macro::Symbol, nodes.shift.symbol
      val = _.dynamic_context.bells_eval nodes.shift
      _.dynamic_context[var] = val
      val
    end
    
    @env[var :"->"] = create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      
      _.dynamic_context.create_a Macro::Func, _.dynamic_context do |_, *args|
        e = _.create_a Macro::Eval
        params.each { |a| e[e.var a.symbol] = args.shift }
        e.bells_eval *stats
      end
    end
  end
end