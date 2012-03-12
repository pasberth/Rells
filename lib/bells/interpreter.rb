require 'bells/core_ext'
require 'bells/syntax'
require 'bells/runtime'

module Bells
  module Interpreter
    include Bells::Syntax
    include Bells::Runtime
    
    extend self
  
    def bells *argv
      main = Main.new
      main.main *argv
    end
  end
end

require 'bells/interpreter/syntax'
require 'bells/interpreter/runtime'
require 'bells/interpreter/main'
