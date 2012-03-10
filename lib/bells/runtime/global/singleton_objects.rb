require 'bells/runtime'
require 'bells/runtime/global'

module Bells::Runtime::Global::SingletonObjects

  include Bells::Runtime
  extend Bells::Runtime::Global::InitialLoader
  
  def bells_init_env_singleton_objects env
    env[:nil] = env.create_a Macro::Nil
    env[:true] = env.create_a Macro::True
    env[:false] = env.create_a Macro::False
  end
end