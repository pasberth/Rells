require 'bells/interpreter'

module Bells::Runtime
  
  module Macro
    
    def bells_eval_str string
      bells_eval_io(StringIO.new(string))
    end

    def bells_eval_io input
      parser = ::Bells::Syntax::Parser.new
      node = parser.parse input
      bells_eval node
    end
  end
end