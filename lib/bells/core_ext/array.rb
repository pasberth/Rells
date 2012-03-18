class Array

  def split_in_while &block
    group = group_by &block
    drop = [*group.delete(false), *group.delete(nil)]
    take = group.each_value.flat_map.itself
    [take, drop]
  end
 
  def take_while! &block
    result = take_while &block
    shift(result.count) if block_given?
    result
  end
  
  alias shift_while take_while!
  
  def drop_while! &block
    result = drop_while &block
    pop(result.count) if block_given?
    result
  end

  alias shift_while take_while!  
  alias pop_while drop_while!
end