require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Env < Bells::Runtime::Macro::Eval
  
  def init_env
    @env[var :to_s] = create_a Macro::Func do |_, *args|
      _.inspect
    end

    @env[var :eval] = create_a Macro::Func do |_, *args|
      args.last
    end

    @env[var :puts] = create_a Macro::Func do |_, *args|
      puts args.map { |a| a[var :to_s].bells_eval }
    end
  end
end