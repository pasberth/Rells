require 'bells/interpreter'

module Bells::Runtime
  
  class Macro
    
    def bells_eval_str string
      bells_eval_io(StringIO.new(string))
    end

    def bells_eval_io input
      parser = ::Bells::Syntax::Parser.new
      node = parser.parse input
      node = syntax_node_to_runtime_node(node)
      eval node
    end
  end
end