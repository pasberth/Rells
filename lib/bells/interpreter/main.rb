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

  def run
    @global.bells_require 'bells/lang'
    node = @parser.parse options[:main]
    puts node
    @global.bells_eval node
    true
  end
end