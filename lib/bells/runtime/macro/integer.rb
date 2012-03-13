require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::Integer < Bells::Runtime::Macro::Object

  def init_env env
    super
    env[:to_s] = create_a Macro::String, receiver.to_s

    env[:+] = create_a Macro::Func, self do |_, *a|
      _.dynamic_context.create_a Macro::Integer, a.inject(_.receiver.receiver) { |r, o| r + o.receiver }
    end

    env[:*] = create_a Macro::Func, self do |_, *a|
      _.dynamic_context.create_a Macro::Integer, a.inject(_.receiver.receiver) { |r, o| r * o.receiver }
    end

    env[:-] = create_a Macro::Func, self do |_, *a|
      _.dynamic_context.create_a Macro::Integer, a.inject(_.receiver.receiver) { |r, o| r - o.receiver }
    end

    env[:==] = create_a Macro::Func, self do |_, *a|
      if _.receiver.receiver == a[0].receiver
        _.env[:true]
      else
        _.env[:false]
      end
    end

    env[:/] = create_a Macro::Func, self do |_, *a|
      _.dynamic_context.create_a Macro::Integer, a.inject(_.receiver.receiver) { |r, o| r / o.receiver }
    end

    env[:<] = create_a Macro::Func, self do |_, *a|
      if _.receiver.receiver < a[0].receiver
        _.env[:true]
      else
        _.env[:false]
      end
    end

    env[:>] = create_a Macro::Func, self do |_, *a|
      if _.receiver.receiver > a[0].receiver
        _.env[:true]
      else
        _.env[:false]
      end
    end

    env[:%] = create_a Macro::Func, self do |_, *a|
      _.dynamic_context.create_a Macro::Integer, a.inject(_.receiver.receiver) { |r, o| r % o.receiver }
    end

    env[:times] = create_a Macro::Func, self do |_, *a|
      a.inject(_.env[:nil]) do |r, o|
        _.receiver.receiver.times { |n| o.eval create_a(Macro::Node::Integer, n) } 
      end
    end
  end

  def eql? other
    receiver.eql? other.receiver
  rescue
    false
  end
  
  def hash
    receiver.hash
  end
  
  def == other
    receiver == other.receiver
  rescue
    false
  end
end
