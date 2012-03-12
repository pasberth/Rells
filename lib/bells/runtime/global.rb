require 'bells/runtime'

class Bells::Runtime::Global < Bells::Runtime::Macro::Eval
  
  def initialize
    super nil
  end

  require 'bells/runtime/global/initial_loader'
  require 'bells/runtime/global/singleton_objects' 
  require 'bells/runtime/global/environment_variables'
  require 'bells/runtime/global/syntax_macros'
  require 'bells/runtime/global/builtin_functions'

  include SingletonObjects
  include EnvironmentVariables
  include SyntaxMacros
  include BuiltinFunctions

  def init_env env
    super
    bells_init_env_singleton_objects env
    bells_init_env_environment_variables env
    bells_init_env_syntax_macros env
    bells_init_env_builtin_functions env

    env[:global] = self
    env[:to_s] = create_a Macro::String, "(global)"
    env[:nil?] = env[:false]
  end
end