require 'bells/runtime'
require 'bells/runtime/global'
require 'bells/runtime/global/initial_loader'
require 'bells/runtime/global/builtin_functions'

module Bells::Runtime::Global::BuiltinFunctions

  initial_load do |env|
    env[:require] = env.create_a Macro::Func, self do |_, f, *args|
      fname = args.shift
      env[:"$LOAD_PATH"].each do |path|
        if File.exist? "#{path}/#{fname}.bells"
          fname = "#{path}/#{fname}.bells"
        else
          next
        end
        io = open fname
        toplevel = Bells::Syntax::Parser.new.parse io
        f.bells_dynamic_eval toplevel
      end
    end

  end
end
