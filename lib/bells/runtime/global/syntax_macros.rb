require 'bells/runtime'
require 'bells/runtime/global'

module Bells::Runtime::Global::SyntaxMacros
  
  include Bells::Runtime
  extend Bells::Runtime::Global::InitialLoader

  initial_loader :bells_init_env_syntax_macros
end

require 'bells/runtime/global/syntax_macros/macro'
require 'bells/runtime/global/syntax_macros/define'
require 'bells/runtime/global/syntax_macros/if'
require 'bells/runtime/global/syntax_macros/lambda'
require 'bells/runtime/global/syntax_macros/meta_string'