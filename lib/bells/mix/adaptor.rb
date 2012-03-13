require 'bells/mix'

class Bells::Mix::Adaptor < Bells::Runtime::Macro::Object
  
  def init_env env
    super
    receiver.methods.each do |f|
      env[f] = create_a Macro::Func, receiver do |_, *a|
        _.create_a ::Bells::Mix::Adaptor,  _.receiver.send(f, *a.map { |e| e.receiver })
      end
    end
  end

  def to_s
    receiver.to_s
  end
  
  def inspect
    receiver.inspect
  end
end

class Bells::Mix::RBAdaptor < BasicObject
  
  private *instance_methods
  
  def initialize bells_macro
    @bells_macro = bells_macro
  end

  def [] f, *args
    ::Bells::Mix::RBAdaptor.new @bells_macro.env[f].eval(*args.map { |e| @bells_macro.create_a(::Bells::Mix::Adaptor, e) })
  end

  def []= key, value
    ::Bells::Mix::RBAdaptor.new(@bells_macro.env[key] = @bells_macro.create_a(::Bells::Mix::Adaptor, value))
  end

  def method_missing f, *a, &b
    super if [:to_str, :to_sym, :to_io, :to_ary, :to_proc, :to_hash, :to_regexp, :to_int, :to_float].include? f 
    if @bells_macro.respond_to? f
      @bells_macro.send f, *a, &b
    else
      ::Bells::Mix::RBAdaptor.new @bells_macro.env[f].eval(*a.map { |e| @bells_macro.create_a(::Bells::Mix::Adaptor, e) })
    end
  end
end
