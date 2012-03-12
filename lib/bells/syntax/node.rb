require 'bells/syntax'
require 'bells/syntax/bellsc'

class Bells::Syntax::Node
  include Bells::Syntax
  include Bells::Syntax::Bellsc
end

require 'bells/syntax/node/symbol'
require 'bells/syntax/node/string'
require 'bells/syntax/node/integer'
require 'bells/syntax/node/macro'
require 'bells/syntax/node/comment'