require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Global < Bells::Runtime::Macro::Eval
  
  def bells_init_env env
    env[:nil] = env.create_a Macro::Nil
    env[:true] = env.create_a Macro::True
    env[:false] = env.create_a Macro::False
    env[:global] = self
    env[:to_s] = bells_value "(global)"
    

    env[:eval] = env.create_a Macro::Func, self do |_, *args|
      args.last
    end
    
    env[:"$LOAD_PATH"] = bells_value [(::File.dirname(__FILE__) + '/../../../pure')]
    
    env[:require] = env.create_a Macro::Func, self do |_, *args|
      fname = args.shift
      env[:"$LOAD_PATH"].each do |path|
        if File.exist? "#{path}/#{fname}.bells"
          fname = "#{path}/#{fname}.bells"
        else
          next
        end
        io = open fname
        toplevel = Bells::Syntax::Parser.new.parse io
        _.bells_dynamic_eval toplevel
      end
    end

    env[:puts] = env.create_a Macro::Func, self do |_, *args|
      puts args.map { |a| a.bells_env[:to_s].bells_eval.to_rb }
      _.bells_env[:nil]
    end
    
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
    
    env[:nil?] = env[:true]
    
    env[:define] = bells_create_a Macro::PureMacro do |_, *nodes|
      var = _.bells_env.dynamic_context.bells_create_a Macro::Symbol, nodes.shift.symbol
      val = _.bells_env.dynamic_context.bells_eval nodes.shift
      _.bells_env.dynamic_context.bells_env[var] = val
      val
    end
    
    env[:"->"] = bells_create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      
      _.bells_env.dynamic_context.bells_create_a Macro::Func, _.bells_env.dynamic_context do |_, *args|
        e = _.bells_create_a Macro::Eval
        params.each { |a| e.bells_env[_.bells_value a.symbol] = args.shift }
        e.bells_eval *stats
      end
    end
    
    env[:object] = env.create_a Macro::PureMacro do |_, *nodes|
      _.bells_env.dynamic_context.bells_create_a Macro::Object
    end
    
    env[:array] = env.create_a Macro::Func, self do |_, *elems|
      _.bells_dynamic_create_a Macro::Array, elems
    end
    
    env[:if] = env.create_a Macro::PureMacro do |_, *nodes|
      cond, stats = nodes.split_in_while { |a| not a.is_a? Bells::Syntax::Node::Macro }
      unless cond.empty?
        cond = Bells::Syntax::Node::Macro.new(cond[0], *cond[1..-1])
      else
        cond = stats.shift
      end
      begin
        ret = _.bells_dynamic_eval(cond)
        if _then = stats.shift and ret.bells_env[:nil?].bells_eval.bells_condition
          ret = _.bells_dynamic_eval _then
          break
        end
      end while cond = stats.shift
      ret
    end
  end
end
