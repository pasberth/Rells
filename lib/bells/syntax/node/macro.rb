require 'bells/syntax/node'

class Bells::Syntax::Node::Macro < Bells::Syntax::Node
  
  attr_reader :node, :args

  def initialize node, *args
    @node = node
    @args = args
  end
  
  def dump_bellsc
    bellsc = ""
    bellsc << BELLSC_MACRO_BEGIN
    bellsc << node.dump_bellsc
    args.each { |a| bellsc << a.dump_bellsc }
    bellsc << BELLSC_EXP_END
    bellsc
  end
  
  def == other
    node == other.node
    args == other.args
  rescue
    false
  end
  
  def to_s
    "( #{node} #{args.join ' '} )"
  end
end