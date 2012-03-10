require 'bells/runtime/macro'

class Bells::Runtime::Macro::Array < Bells::Runtime::Macro::Object
  
  attr_reader :array

  def initialize *array
    super
    @array = array
  end
  
  def init_env
    @env[var :to_s] = create_a Macro::Func, self do |_, *a|
      _.receiver.create_a Macro::String, _.receiver.array.map { |b| b[var :to_s].bells_eval.string }.join(', ')
    end
  end

  def eql? other
    @array.eql? other.array
  rescue
    false
  end
  
  def hash
    @array.hash
  end
  
  def == other
    @array == other.array
  rescue
    false
  end
end
