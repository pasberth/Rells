require 'bells/runtime/macro'

class Bells::Runtime::Macro::Integer < Bells::Runtime::Macro::Object
  
  attr_reader :integer

  def initialize integer
    super
    @integer = integer
  end
  
  def init_env
    @env[var :to_s] = create_a Macro::Func, self do |_, *a|
      _.receiver.create_a(Macro::String, _.receiver.integer.to_s)
    end

    @env[var :+] = create_a Macro::Func, self do |_, *a|
      i  = _.receiver.integer
      dynamic_context.create_a Macro::Integer, a.inject(i) { |r, o| r + o.receiver.integer }
    end

    @env[var :*] = create_a Macro::Func, self do |_, *a|
      i  = _.receiver.integer
      dynamic_context.create_a Macro::Integer, a.inject(i) { |r, o| r * o.receiver.integer }
    end

    @env[var :-] = create_a Macro::Func, self do |_, *a|
      i  = _.receiver.integer
      dynamic_context.create_a Macro::Integer, a.inject(i) { |r, o| r - o.receiver.integer }
    end

    @env[var :/] = create_a Macro::Func, self do |_, *a|
      i  = _.receiver.integer
      dynamic_context.create_a Macro::Integer, a.inject(i) { |r, o| r / o.receiver.integer }
    end

    @env[var :<] = create_a Macro::Func, self do |_, *a|
      if _.receiver.integer < a[0].receiver.integer
        self[var :true]
      else
        self[var :false]
      end
    end

    @env[var :>] = create_a Macro::Func, self do |_, *a|
      if _.receiver.integer > a[0].receiver.integer
        self[var :true]
      else
        self[var :false]
      end
    end

    @env[var :times] = create_a Macro::Func, self do |_, *a|
      a.inject(nil) { |r, o| _.receiver.integer.times { |n| o.bells_eval Bells::Syntax::Node::Integer.new(n) } }
    end
  end

  def eql? other
    @string.eql? other.string
  rescue
    false
  end
  
  def hash
    @string.hash
  end
  
  def == other
    string == other.string
  rescue
    false
  end
end
