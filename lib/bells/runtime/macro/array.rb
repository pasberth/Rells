require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::Array < Array
  
  include Bells::Runtime::Macro::Objectable
  
  def to_rb
    map { |e| e.to_rb }
  end
  
  def bells_init_env env
    super

    env[:to_s] = bells_create_a Macro::Func, self do |*a|
      _ = a.shift
      f = a.shift
      bells_value('[%s]' % _.map { |e| e.bells_env[:to_s].bells_eval.to_rb }.join(', '))
    end

    env[:<<] = bells_create_a Macro::Func, self do |*a|
      _ = a.shift
      f = a.shift
      a.each { |e| _ << e }
      _
    end
  end
end
