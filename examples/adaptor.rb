$:.unshift File.dirname(__FILE__) + "/../lib"

require 'bells'
require 'bells/mix'

include Bells::Mix

BELLS_GLOBAL[:"$LOAD_PATH"] << (File.dirname(__FILE__) + "/adaptor")
BELLS_GLOBAL.require 'hello_adaptor'

BELLS_GLOBAL.require 'connect_bells'
puts BELLS_GLOBAL[:"bells_value"]

rb_value = "hello"
BELLS_GLOBAL[:"rb_value"] = rb_value
BELLS_GLOBAL.require 'receive_rb_value'
puts rb_value # hello world
