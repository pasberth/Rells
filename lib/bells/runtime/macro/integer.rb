require 'bells/runtime/macro'
require 'bells/runtime/macro/object'

class Bells::Runtime::Macro::Integer < Bells::Runtime::Macro::Object
  
  def to_rb
    @integer
  end

  attr_reader :integer
  
  def initialize integer
    super
    @integer = integer
  end
  
  def bells_init_env env
    env[:to_s] = env.create_a Macro::Func, self do |_, *a|
      _.bells_value(_.to_rb.to_s)
    end

    env[:+] = env.create_a Macro::Func, self do |_, *a|
      _.bells_dynamic_create_a Macro::Integer, a.inject(_.to_rb) { |r, o| r + o.to_rb }
    end

    env[:*] = env.create_a Macro::Func, self do |_, *a|
      _.bells_dynamic_create_a Macro::Integer, a.inject(_.to_rb) { |r, o| r * o.to_rb }
    end

    env[:-] = env.create_a Macro::Func, self do |_, *a|
      _.bells_dynamic_create_a Macro::Integer, a.inject(_.to_rb) { |r, o| r - o.to_rb }
    end

    env[:==] = env.create_a Macro::Func, self do |_, *a|
      if _.to_rb == a[0].to_rb
        _.bells_env[:true]
      else
        _.bells_env[:false]
      end
    end

    env[:/] = env.create_a Macro::Func, self do |_, *a|
      _.bells_dynamic_create_a Macro::Integer, a.inject(_.to_rb) { |r, o| r / o.to_rb }
    end

    env[:<] = env.create_a Macro::Func, self do |_, *a|
      if _.to_rb < a[0].to_rb
        _.bells_env[:true]
      else
        _.bells_env[:false]
      end
    end

    env[:>] = env.create_a Macro::Func, self do |_, *a|
      if _.to_rb > a[0].to_rb
        _.bells_env[:true]
      else
        _.bells_env[:false]
      end
    end
    
    env[:%] = env.create_a Macro::Func, self do |_, *a|
      _.bells_dynamic_create_a Macro::Integer, a.inject(_.to_rb) { |r, o| r % o.to_rb }
    end

    env[:times] = env.create_a Macro::Func, self do |_, *a|
      a.inject(_.bells_env[:nil]) do |r, o|
        _.to_rb.times { |n| o.bells_eval Bells::Syntax::Node::Integer.new(n) } 
      end
    end
  end

  def eql? other
    @integer.eql? other.integer
  rescue
    false
  end
  
  def hash
    @integer.hash
  end
  
  def == other
    integer == other.integer
  rescue
    false
  end
end
