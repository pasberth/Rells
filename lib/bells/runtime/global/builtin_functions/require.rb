require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:require] = create_a Macro::Func, self do |_, *args|
      fname = args.shift
      env[:"$LOAD_PATH"].receiver.each do |path|
        if File.exist? "#{path}/#{fname}.bellsc" and File.ctime("#{path}/#{fname}.bellsc") > File.ctime("#{path}/#{fname}.bells")
          fname = "#{path}/#{fname}.bellsc"
          io = open fname, "rb"
          toplevel = Bells::Syntax::Parser.new.decode_bellsc io
          io.close
          _.dynamic_context.eval toplevel
        elsif File.exist? "#{path}/#{fname}.bells"
          io = open "#{path}/#{fname}.bells"
          parser = Bells::Syntax::Parser.new
          toplevel = parser.parse(io)
          io.close
          bellsc = parser.encode_bellsc(toplevel)
          open "#{path}/#{fname}.bellsc", "wb" do |f| f.write bellsc end
          _.dynamic_context.eval toplevel
        end
      end
    end

  end
end
