require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'

module Bells::Runtime::Global::BuiltinFunctions

  include Bells::Runtime
  extend Bells::Runtime::Global::InitialLoader
  
  initial_loader :bells_init_env_builtin_functions
end

require 'bells/runtime/global/builtin_functions/require'
require 'bells/runtime/global/builtin_functions/eval'
require 'bells/runtime/global/builtin_functions/puts'
require 'bells/runtime/global/builtin_functions/array'
require 'bells/runtime/global/builtin_functions/object'
