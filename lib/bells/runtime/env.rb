require 'bells/runtime'
require 'bells/runtime/macro'

class Bells::Runtime::Env < Bells::Runtime::Macro::Eval
  
  def initialize
    super
    init
  end

  def init
    @env[create_a Macro::Symbol, "to_s"] = create_a Macro::Func do |*args|
      args.inspect
    end

    @env[create_a Macro::Symbol, "eval"] = create_a Macro::Func do |*args|
      args.last
    end

    @env[create_a Macro::Symbol, "puts"] = create_a Macro::Func do |*args|
      puts args.map(&:inspect)
    end
  end
end