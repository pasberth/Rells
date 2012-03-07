require 'bells/syntax'
require 'bells/runtime'

module Bells
  module Interpreter
    include Bells::Syntax
    include Bells::Runtime
    
    extend self
  
    def bells argv
      f = argv.shift
      main = Main.new main: open(f)
      main.run
    end
  end
end

require 'bells/interpreter/main'
