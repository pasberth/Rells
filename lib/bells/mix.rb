require 'bells/core_ext'
require 'bells/runtime'

module Bells
  module Mix
    include Bells::Runtime
  end
end

require 'bells/mix/adaptor'
require 'bells/mix/global'
