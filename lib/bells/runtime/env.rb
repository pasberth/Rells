require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Env < Bells::Runtime::Macro::Eval
  
  def init_env
    @env[var :to_s] = create_a Macro::Func, self do |_, *args|
      _.create_a Bells::Runtime::Macro::String, "(global)"
    end

    @env[var :eval] = create_a Macro::Func, self do |_, *args|
      args.last
    end

    @env[var :puts] = create_a Macro::Func, self do |_, *args|
      puts args.map { |a| a.bells_eval[var :to_s].bells_eval.string }
    end
    
    @env[var :define] = create_a Macro::PureMacro do |_, *nodes|
      var = _.bells_eval nodes.shift
      val = _.bells_eval nodes.shift
      _[var] = val
      val
    end
    
    @env[var :"->"] = create_a Macro::PureMacro do |_, *nodes|
      params = nodes.take_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      stats = nodes.drop_while { |a| a.is_a? Bells::Syntax::Node::Symbol }
      
      _.create_a Macro::Func, _ do |_, *args|
        e = _.create_a Macro::Eval
        params.each { |a| e[e.create_a Macro::Symbol, a.symbol] = args.shift }
        e.bells_eval *stats
      end
    end
  end
end