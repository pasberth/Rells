require 'bells/runtime'
require 'bells/runtime/global'

module Bells::Runtime::Global::EnvironmentVariables
  
  include Bells::Runtime
  extend Bells::Runtime::Global::InitialLoader
  
  initial_loader :bells_init_env_environment_variables
end

require 'bells/runtime/global/environment_variables/load_path'