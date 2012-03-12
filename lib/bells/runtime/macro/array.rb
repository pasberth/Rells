require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::Array < Bells::Runtime::Macro::Object

  def == other
    receiver == other.receiver
  rescue
    false
  end

  def eql? other
    receiver.eql? other.receiver
  rescue
    false
  end

  def hash
    receiver.hash
  end

  def init_env env
    super

    env[:to_s] = create_a Macro::Func, self do |_, *a|
      _.create_a(Macro::String, ('[%s]' % _.receiver.receiver.map { |e| e.env[:to_s].eval }.join(', ')))
    end

    env[:<<] = create_a Macro::Func, self do |_, *a|
      a.each { |e| _.receiver.receiver << e }
      _
    end
  end
end