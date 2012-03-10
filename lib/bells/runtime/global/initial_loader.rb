require 'bells/runtime'
require 'bells/runtime/global'

module Bells::Runtime::Global::InitialLoader
  
  def initial_loader tag, &block

    count = 0

    define_method tag do |*args|
      count.times { |n| send :"__#{tag}_#{n}", self, *args }
    end

    define_singleton_method :initial_load do |&block|
      define_method :"__#{tag}_#{count}" do |context, *args|
        context.instance_exec(*args, &block)
      end
      count += 1
      true
    end
  end
end