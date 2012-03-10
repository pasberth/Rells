require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Env < Bells::Runtime::Macro::Eval
  
  def init_env
    @env[var :global] = self
    @env[var :to_s] = create_a Macro::String, "(global)"
    
    @env[var :nil] = create_a Macro::Nil
    @env[var :true] = create_a Macro::True
    @env[var :false] = create_a Macro::False

    @env[var :eval] = create_a Macro::Func, self do |_, *args|
      args.last
    end
    
    @env[var :"$LOAD_PATH"] = create_a Macro::Array, create_a(Macro::String, File.dirname(__FILE__) + '/../../../pure')
    
    @env[var :require] = create_a Macro::Func, self do |_, *args|
      fname = args.shift
      @env[var :"$LOAD_PATH"].array.each do |path|
        if File.exist? "#{path.string + '/' + fname.string}.bells"
          fname = "#{path.string + '/' + fname.string}.bells"
        elsif File.exist? "#{path.string + '/' +fname.string}"
          fname = "#{path.string + '/' +fname.string}"
        else
          next
        end
        io = open fname
        toplevel = Bells::Syntax::Parser.new.parse io
        _.dynamic_context.bells_eval toplevel
      end
    end

    @env[var :puts] = create_a Macro::Func, self do |_, *args|
      puts args.map { |a| a[var :to_s].bells_eval.string }
      _.receiver[_.receiver.var :nil]
    end
    
    @env[var :macro] = create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      _.dynamic_context.create_a Macro::PureMacro do |_, *args|
        args = Hash[*params.flat_map do |a|
          case a.symbol[0]
          when '*'
            ret = [a, args.clone]
            args.clear
            ret
          else
            [a, args.shift || _.dynamic_context[var :nil]]
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
        _.dynamic_context.bells_eval *stats.map { |node| expand.(node) }
      end
    end
    
    @env[var :nil?] = @env[var :true]
    
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
    
    @env[var :object] = create_a Macro::PureMacro do |_, *nodes|
      _.dynamic_context.create_a Macro::Object
    end
    
    @env[var :if] = create_a Macro::PureMacro do |_, *nodes|
      cond, stats = nodes.split_in_while { |a| not a.is_a? Bells::Syntax::Node::Macro }
      unless cond.empty?
        cond = Bells::Syntax::Node::Macro.new(cond[0], *cond[1..-1])
      else
        cond = stats.shift
      end
      begin
        ret = _.dynamic_context.bells_eval(cond)
        if _then = stats.shift and ret[var :nil?].bells_eval.condition
          ret = _.dynamic_context.bells_eval _then
          break
        end
      end while cond = stats.shift
      ret
    end
  end
end