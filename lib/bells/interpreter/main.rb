require 'bells/interpreter'

class Bells::Interpreter::Main
  
  include Bells::Interpreter

  attr_reader :options
  
  def initialize options={}
    @options = {
      parser: Parser.new,
      global: Env.new
    }.merge(options).each do |att, val|
      instance_variable_set :"@#{att}", val
    end
  end

  def run
    node = @parser.parse options[:main]
    @global.bells_eval node
    true
  end
end