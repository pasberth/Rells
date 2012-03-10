module Bells
  module Syntax
    class SyntaxError < StandardError
    end
  end
end

require 'bells/core_ext'
require 'bells/syntax/node'
require 'bells/syntax/lexer'
require 'bells/syntax/parser'