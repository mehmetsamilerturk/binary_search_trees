class Node
  attr_accessor :data, :left, :right
  
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_reader :root

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(array, start = 0, end_array = array.length - 1)
    return nil if start > end_array
    mid = ((start + end_array) / 2)
    root_node = Node.new(array[mid])
    root_node.left = build_tree(array, start, mid - 1)
    root_node.right = build_tree(array, mid + 1, end_array)
    return root_node
  end

  def call_each(current)    
    return nil if current.nil?
    
    puts current.data
    call_each(current.left)
    call_each(current.right)
  end

  def insert(value)
    return nil if current.nil?

    
  end

  def delete(value)
  end
end

numbers = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(numbers)
