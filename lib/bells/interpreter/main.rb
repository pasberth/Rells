require 'bells/interpreter'

class Bells::Interpreter::Main
  
  include Bells::Interpreter

  attr_reader :options
  
  def initialize options={}
    @options = {
      parser: Parser.new,
      global: Global.new
    }.merge(options).each do |att, val|
      instance_variable_set :"@#{att}", val
    end
  end
  
  def main *argv

    f = argv.shift

    if f !~ /^(.*)\.bells$/
      return sub_command(f, *argv)
    end

    bells = f
    bellsc = "#{$1}.bellsc"

    if File.exist? bellsc
      options[:main_bellsc] = open bellsc, "rb"
    else
      options[:main] = open bells
    end

    run *argv
  end
  
  def sub_command cmd, *args
    if [:compile, :run].include? cmd.to_sym
      send cmd, *args
    else
      fail
    end
  end
  
  def compile *targets
    targets.each do |f|
      if f =~ /^(.*)\.bells$/
        bells = f
        bellsc = "#{$1}.bellsc"
      else
        bells = "#{f}.bells"
        bellsc = "#{f}.bellsc"
      end
      
      open bells do |f|
        open bellsc, "wb" do |g|
          node = @parser.parse(f)
          bellsc = @parser.encode_bellsc(node)
          g.write bellsc
        end
      end
    end
  end

  def run *args
    @global.bells_require 'bells/lang'
    if f = options[:main]
      node = @parser.parse f
    elsif f = options[:main_bellsc]
      node = @parser.decode_bellsc f
    end
    puts node
    @global.bells_eval node
    true
  end
end