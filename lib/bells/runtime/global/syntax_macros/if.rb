require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/syntax_macros'

module Bells::Runtime::Global::SyntaxMacros

  initial_load do |env|
    env[:if] = create_a Macro::PureMacro do |_, *nodes|
      cond, stats = nodes.split_in_while { |a| not a.is_a? Bells::Syntax::Node::Macro }
      unless cond.empty?
        cond = Bells::Syntax::Node::Macro.new(cond[0], *cond[1..-1])
      else
        cond = stats.shift
      end
      begin
        ret = _.dynamic_context.eval(cond)
        if _then = stats.shift and !ret.env[:nil?].eval.condition
          ret = _.dynamic_context.eval _then
          break
        end
      end while cond = stats.shift
      ret
    end
  end
end
