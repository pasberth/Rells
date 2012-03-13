require 'bells/runtime/macro'

class Bells::Runtime::Macro::Eval < Bells::Runtime::Macro
  
  def eval *nodes
    nodes.inject(env[:nil]) { |result, node| node.bind(self).eval }
  end
end
