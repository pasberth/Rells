require 'bells/runtime'

class Bells::Runtime::Global < Bells::Runtime::Macro::Eval

  require 'bells/runtime/global/initial_loader'
  require 'bells/runtime/global/singleton_objects' 
  require 'bells/runtime/global/environment_variables'
  require 'bells/runtime/global/syntax_macros'
  require 'bells/runtime/global/builtin_functions'

  include SingletonObjects
  include EnvironmentVariables
  include SyntaxMacros
  include BuiltinFunctions

  def bells_init_env env
    bells_init_env_singleton_objects env
    bells_init_env_environment_variables env
    bells_init_env_syntax_macros env
    bells_init_env_builtin_functions env

    env[:global] = self
    env[:to_s] = bells_value "(global)"
    env[:nil?] = env[:true]
  end
end